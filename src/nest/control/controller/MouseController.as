package nest.control.controller 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.event.MouseEvent3D;
	import nest.object.IMesh;
	import nest.view.process.IContainerProcess;
	import nest.view.shader.Shader3D;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * MouseController
	 */
	public class MouseController {
		
		private var id:uint;
		private var mouseX:Number = 0;
		private var mouseY:Number = 0;
		private var target:IMesh;
		private var program:Program3D;
		
		public var stage:Stage;
		public var containerProcess:IContainerProcess;
		
		public function MouseController(stage:Stage, containerProcess:IContainerProcess) {
			this.stage = stage;
			this.containerProcess = containerProcess;
			
			program = ViewPort.context3d.createProgram();
			program.upload(Shader3D.assembler.assemble(Context3DProgramType.VERTEX, "m44 vt0, va0, vc0\nm44 op, vt0, vc4\n"), 
							Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, "mov oc, fc0"));
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			stage.addEventListener(MouseEvent.CLICK, onMouseEvent);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, onMouseEvent);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseEvent);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onMouseEvent);
		}
		
		public function calculate():void {
			if (!containerProcess.container || !containerProcess.container.visible) return;
			
			var camera:Camera3D = containerProcess.camera;
			var context3d:Context3D = ViewPort.context3d;
			var width:Number = ViewPort.width;
			var height:Number = ViewPort.height;
			
			if (mouseX <= width && mouseY <= height) {
				var raw:Vector.<Number> = camera.pm.rawData.concat();
				raw[8] = -mouseX * 2 / width;
				raw[9] = mouseY * 2 / height;
				var pm:Matrix3D = camera.invertWorldMatrix.clone();
				pm.append(new Matrix3D(raw));
				
				context3d.setRenderToBackBuffer();
				context3d.clear();
				
				var bmd:BitmapData = new BitmapData(1, 1, true, 0);
				var mesh:IMesh;
				var i:int = 0;
				
				for each(mesh in containerProcess.objects) {
					if (mesh.mouseEnabled) {
						mesh.id = ++i;
						context3d.setCulling(mesh.triangleCulling);
						context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mesh.worldMatrix, true);
						context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, pm, true);
						context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, ((i >> 8) & 0xff) / 255, (i & 0xff) / 255, 1]));
						context3d.setProgram(program);
						context3d.setVertexBufferAt(0, mesh.geometry.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
						context3d.drawTriangles(mesh.geometry.indexBuffer);
						context3d.setVertexBufferAt(0, null);
					}
				}
				
				context3d.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				
				for each(mesh in containerProcess.alphaObjects) {
					if (mesh.mouseEnabled) {
						mesh.id = ++i;
						context3d.setCulling(mesh.triangleCulling);
						context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mesh.worldMatrix, true);
						context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, pm, true);
						context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, ((i >> 8) & 0xff) / 255, (i & 0xff) / 255, 1]));
						context3d.setProgram(program);
						context3d.setVertexBufferAt(0, mesh.geometry.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
						context3d.drawTriangles(mesh.geometry.indexBuffer);
						context3d.setVertexBufferAt(0, null);
					}
				}
				
				context3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
				
				context3d.drawToBitmapData(bmd);
				context3d.present();
				id = bmd.getPixel32(0, 0) & 0xffff;
				
				if (id != 0) {
					for each(mesh in containerProcess.objects) {
						if (mesh.mouseEnabled && mesh.id == id) {
							if (target != mesh) {
								if (target) target.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OUT));
								mesh.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OVER));
							}
							target = mesh;
						}
					}
				} else {
					if (target) target.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OUT));
					target = null;
				}
			}
		}
		
		public function dispose():void {
			containerProcess = null;
			program.dispose();
			program = null;
			target = null;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			stage.removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			stage.removeEventListener(MouseEvent.CLICK, onMouseEvent);
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, onMouseEvent);
			stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseEvent);
			stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, onMouseEvent);
			stage = null;
		}
		
		private function onMouseEvent(e:MouseEvent):void {
			var type:String;
			mouseX = stage.mouseX;
			mouseY = stage.mouseY;
			switch(e.type) {
				case MouseEvent.MOUSE_MOVE:
					type = MouseEvent3D.MOUSE_MOVE;
					break;
				case MouseEvent.MOUSE_DOWN:
					type = MouseEvent3D.MOUSE_DOWN;
					break;
				case MouseEvent.MOUSE_UP:
					type = MouseEvent3D.MOUSE_UP;
					break;
				case MouseEvent.CLICK:
					type = MouseEvent3D.CLICK;
					break;
				case MouseEvent.RIGHT_CLICK:
					type = MouseEvent3D.RIGHT_CLICK;
					break;
				case MouseEvent.RIGHT_MOUSE_DOWN:
					type = MouseEvent3D.RIGHT_MOUSE_DOWN;
					break;
				case MouseEvent.RIGHT_MOUSE_UP:
					type = MouseEvent3D.RIGHT_MOUSE_UP;
					break;
			}
			if (target && type) target.dispatchEvent(new MouseEvent3D(type));
		}
		
	}

}