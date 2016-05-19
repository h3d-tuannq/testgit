package interfaces
{
	import flash.utils.ByteArray;

	public interface IUndoModel
	{
		function tryToAMF():ByteArray;
		
		function tryFromAMF(amf:ByteArray):Object;
	}
}