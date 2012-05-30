package nest.object.data
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Vector3D;
	
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	
	/**
	 * MeshData
	 */
	public class MeshData {
		
		private var _vertexBuffer:VertexBuffer3D;
		private var _uvBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _normalBuffer:VertexBuffer3D;
		
		private var _vertices:Vector.<Vertex>;
		private var _triangles:Vector.<Triangle>;
		
		private var _vertex:Vector.<Number>;
		private var _uv:Vector.<Number>;
		private var _index:Vector.<uint>;
		private var _normal:Vector.<Number>;
		
		private var _numVertices:int = 0;
		private var _numIndices:int = 0;
		private var _numTriangles:int = 0;
		
		private var _changed:Boolean = false;
		
		public function MeshData(vertices:Vector.<Vertex>, triangles:Vector.<Triangle>) {
			_vertices = vertices;
			_triangles = triangles;
			update();
		}
		
		/**
		 * Call this when you modified vertices/triangles list.
		 */
		public function update():void {
			if (!_vertices && !_triangles) return;
			
			_numVertices = _vertices.length;
			_numTriangles = _triangles.length;
			_numIndices = _triangles.length * 3;
			
			if (_vertex) {
				if (_vertex.length != _numVertices * 3) _vertex = new Vector.<Number>(_numVertices * 3, true);
			} else {
				_vertex = new Vector.<Number>(_numVertices * 3, true);
			}
			if (_index) {
				if(_index.length != _numIndices) _index = new Vector.<uint>(_numIndices, true);
			} else {
				_index = new Vector.<uint>(_numIndices, true);
			}
			if (_uv) {
				if(_uv.length != _numVertices * 2) _uv = new Vector.<Number>(_numVertices * 2, true);
			} else {
				_uv = new Vector.<Number>(_numVertices * 2, true);
			}
			if (_normal) {
				if (_normal.length != _numVertices * 3) _normal = new Vector.<Number>(_numVertices * 3, true);
			} else {
				_normal = new Vector.<Number>(_numVertices * 3, true);
			}
			
			var i:int, j:int;
			var vertex:Vertex;
			var triangle:Triangle;
			
			for (i = 0; i < _numVertices; i++) {
				vertex = _vertices[i];
				// vertex
				j = i * 3;
				_vertex[j] = vertex.x;
				_vertex[j + 1] = vertex.y;
				_vertex[j + 2] = vertex.z;
				// normal
				_normal[j] = vertex.normal.x;
				_normal[j + 1] = vertex.normal.y;
				_normal[j + 2] = vertex.normal.z;
				// uv
				j = i * 2;
				_uv[j] = vertex.u;
				_uv[j + 1] = vertex.v;
			}
			
			for (i = 0; i < _numTriangles; i++) {
				triangle = _triangles[i];
				// index
				j = i * 3;
				_index[j] = triangle.index0;
				_index[j + 1] = triangle.index1;
				_index[j + 2] = triangle.index2;
			}
			
			_changed = true;
		}
		
		public function upload(context3D:Context3D, uv:Boolean, normal:Boolean):void {
			if (_changed) {
				_changed = false;
				if (_vertexBuffer)_vertexBuffer.dispose();
				_vertexBuffer = context3D.createVertexBuffer(_numVertices, 3);
				_vertexBuffer.uploadFromVector(_vertex, 0, _numVertices);
				if (_uvBuffer)_uvBuffer.dispose();
				_uvBuffer = context3D.createVertexBuffer(_numVertices, 2);
				_uvBuffer.uploadFromVector(_uv, 0, _numVertices);
				if (_indexBuffer)_indexBuffer.dispose();
				_indexBuffer = context3D.createIndexBuffer(_numIndices);
				_indexBuffer.uploadFromVector(_index, 0, _numIndices);
				if (_normalBuffer)_normalBuffer.dispose();
				_normalBuffer = context3D.createVertexBuffer(_numVertices, 3);
				_normalBuffer.uploadFromVector(_normal, 0, _numVertices);
			}
			context3D.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if (uv) context3D.setVertexBufferAt(1, _uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			if (normal) context3D.setVertexBufferAt(2, _normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		}
		
		public function unload(context3D:Context3D):void {
			context3D.setVertexBufferAt(0, null, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, null, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(2, null, 0, Context3DVertexBufferFormat.FLOAT_3);
		}
		
		public function dispose():void {
			if (_vertexBuffer)_vertexBuffer.dispose();
			if (_uvBuffer)_uvBuffer.dispose();
			if (_indexBuffer)_indexBuffer.dispose();
			if (_normalBuffer)_normalBuffer.dispose();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get vertices():Vector.<Vertex> {
			return _vertices;
		}
		
		public function get triangles():Vector.<Triangle> {
			return _triangles;
		}
		
		public function get numVertices():int {
			return _numVertices;
		}
		
		public function get numIndices():int {
			return _numIndices;
		}
		
		public function get numTriangles():int {
			return _numTriangles;
		}
		
		public function get indexBuffer():IndexBuffer3D {
			return _indexBuffer;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.object.data.MeshData]";
		}
		
	}

}