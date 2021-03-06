package nest.object
{
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Vector3D;
	
	import nest.control.event.MatrixEvent;
	import nest.control.partition.OcNode;
	import nest.object.Geometry;
	import nest.view.shader.Shader3D;
	
	[Event(name = "transform_change", type = "nest.control.event.MatrixEvent")]
	[Event(name = "mouseDown", type = "nest.control.event.MouseEvent3D")]
	[Event(name = "mouseOver", type = "nest.control.event.MouseEvent3D")]
	[Event(name = "mouseMove", type = "nest.control.event.MouseEvent3D")]
	[Event(name = "mouseOut", type = "nest.control.event.MouseEvent3D")]
	[Event(name = "click", type = "nest.control.event.MouseEvent3D")]
	[Event(name = "doubleClick", type = "nest.control.event.MouseEvent3D")]
	[Event(name = "rightClick", type = "nest.control.event.MouseEvent3D")]
	[Event(name = "rightMouseDown", type = "nest.control.event.MouseEvent3D")]
	
	/**
	 * Mesh
	 */
	public class Mesh extends Object3D implements IMesh {
		
		protected var _geometry:Geometry;
		protected var _shader:Shader3D;
		protected var _batch:Vector.<IParticlePart>;
		
		protected var _max:Vector3D = new Vector3D();
		protected var _min:Vector3D = new Vector3D();
		protected var _triangleCulling:String = Context3DTriangleFace.BACK;
		protected var _node:OcNode;
		
		protected var _cliping:Boolean = true;
		protected var _alphaTest:Boolean = false;
		protected var _mouseEnabled:Boolean = false;
		protected var _ignoreRotation:Boolean = false;
		protected var _visible:Boolean = true;
		protected var _castShadows:Boolean = false;
		protected var _id:uint = 0;
		
		public function Mesh(geometry:Geometry = null, shader:Shader3D = null) {
			super();
			_geometry = geometry;
			_shader = shader;
		}
		
		public function dispose(geometry:Boolean = false, shader:Boolean = false, batch:Boolean = false):void {
			if (geometry) _geometry.dispose();
			if (shader)_shader.dispose();
			if (batch) for each(var part:IParticlePart in _batch) part.dispose();
			_geometry = null;
			_shader = null;
			_batch = null;
			_max = _min = null;
		}
		
		override public function decompose():void {
			super.decompose();
			if (_geometry) {
				_max.copyFrom(_worldMatrix.transformVector(_geometry.max));
				_min.copyFrom(_worldMatrix.transformVector(_geometry.min));
			}
			dispatchEvent(new MatrixEvent(MatrixEvent.TRANSFORM_CHANGE));
		}
		
		override public function recompose():void {
			super.recompose();
			if (_geometry) {
				_max.copyFrom(_worldMatrix.transformVector(_geometry.max));
				_min.copyFrom(_worldMatrix.transformVector(_geometry.min));
			}
			dispatchEvent(new MatrixEvent(MatrixEvent.TRANSFORM_CHANGE));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get geometry():Geometry {
			return _geometry;
		}
		
		public function set geometry(value:Geometry):void {
			_geometry = value;
		}
		
		public function get shader():Shader3D {
			return _shader;
		}
		
		public function set shader(value:Shader3D):void {
			_shader = value;
		}
		
		public function get batch():Vector.<IParticlePart> {
			return _batch;
		}
		
		public function set batch(value:Vector.<IParticlePart>):void {
			_batch = value;
		}
		
		public function get max():Vector3D {
			return _max;
		}
		
		public function get min():Vector3D {
			return _min;
		}
		
		public function get cliping():Boolean {
			return _cliping;
		}
		
		public function set cliping(value:Boolean):void {
			_cliping = value;
		}
		
		public function get alphaTest():Boolean {
			return _alphaTest;
		}
		
		public function set alphaTest(value:Boolean):void {
			_alphaTest = value;
		}
		
		public function get mouseEnabled():Boolean {
			return _mouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void {
			_mouseEnabled = value;
		}
		
		public function get triangleCulling():String {
			return _triangleCulling;
		}
		
		public function set triangleCulling(value:String):void {
			_triangleCulling = value;
		}
		
		public function get id():uint {
			return _id;
		}
		
		public function set id(value:uint):void {
			_id = value;
		}
		
		public function get ignoreRotation():Boolean {
			return _ignoreRotation;
		}
		
		public function set ignoreRotation(value:Boolean):void {
			_ignoreRotation = value;
		}
		
		public function get visible():Boolean {
			return _visible;
		}
		
		public function set visible(value:Boolean):void {
			_visible = value;
		}
		
		public function get castShadows():Boolean {
			return _castShadows;
		}
		
		public function set castShadows(value:Boolean):void {
			_castShadows = value;
		}
		
		public function get node():OcNode {
			return _node;
		}
		
		public function set node(value:OcNode):void {
			_node = value;
		}
		
	}

}