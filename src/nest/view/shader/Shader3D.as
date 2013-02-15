package nest.view.shader 
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	
	import nest.view.ViewPort;
	
	/**
	 * Shader3D
	 */
	public class Shader3D {
		
		public static const assembler:AGALMiniAssembler = new AGALMiniAssembler();
		
		private var _program:Program3D;
		
		public var constantParts:Vector.<IConstantShaderPart> = new Vector.<IConstantShaderPart>();
		
		public function Shader3D() {
			_program = ViewPort.context3d.createProgram();
		}
		
		public function comply(vertex:String, fragment:String):void {
			_program.upload(
				assembler.assemble(Context3DProgramType.VERTEX, vertex), 
				assembler.assemble(Context3DProgramType.FRAGMENT, fragment)
			);
		}
		
		public function dispose():void {
			if(_program)_program.dispose();
			_program = null;
			constantParts = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get program():Program3D {
			return _program;
		}
		
	}

}