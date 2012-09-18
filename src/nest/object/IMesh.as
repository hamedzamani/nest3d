package nest.object 
{	
	import flash.display.Graphics;
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.geom.MeshData;
	import nest.object.geom.IBound;
	import nest.view.material.IMaterial;
	import nest.view.BlendMode3D;
	
	/**
	 * Mesh Interface
	 */
	public interface IMesh extends IObject3D {
		
		function draw(g:Graphics, thickness:Number = 0, color:uint = 0xff0000, alpha:Number = 1.0):void;
		function clone():IMesh;
		
		function get data():MeshData;
		
		function get material():IMaterial;
		
		function get bound():IBound;
		
		function get scale():Vector3D;
		
		function get cliping():Boolean;
		function set cliping(value:Boolean):void;
		
		function get culling():String;
		function set culling(value:String):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get alphaTest():Boolean;
		function set alphaTest(value:Boolean):void;
		
		function get blendMode():BlendMode3D;
		
		function get id():uint;
		function set id(value:uint):void;
		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
		
	}
	
}