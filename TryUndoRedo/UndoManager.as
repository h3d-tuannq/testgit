package util
{
	import flash.utils.ByteArray;
	
	import flashx.undo.UndoManager;
	
	import interfaces.IUndoModel;
	
	import net.projeckit.model.IUndoableModel;
	import net.projectkit.model.Project;
	
	//[PropertyBinding(hostChain="_model", targetField="undoManager.model")]
	//[PropertyBinding(hostChain="TaskModule._model", targetField="@model@")]
	public class UndoManager extends flashx.undo.UndoManager
	{
		private static var _instances:Object = {};
		//Dat ten lai la: undoStackStorage
		private var undoStackStorage:Vector.<Object> = new Vector.<Object>;
		
		[Bindable]
		public var model:IUndoModel;
		
		private var _curentState:int = -1;
		
		public function UndoManager()
		{
			
		}
		
		public static function getInstanceByViewId(viewId:String):util.UndoManager
		{
			var um:util.UndoManager;
			if (_instances[viewId] == undefined)
			{
				um = new util.UndoManager();
				um.undoAndRedoItemLimit = 20;
				_instances[viewId] = um;
			}
			else
			{
				um = _instances[viewId] as util.UndoManager;
			}
			return um;
		}
		
		//doi ten thanh recordChange
		public function recordChange():void
		{
			 if ( model is IUndoableModel)
				var dataByteArray:ByteArray = (model).toAMF(); 
			 if (dataByteArray != null){
				 _curentState++;
				 undoStackStorage.splice(_curentState,undoStackStorage.length - _curentState,dataByteArray);
			 }	 
		}
		
		public function performUndo():void
		{
			
			if ((_curentState>0) && (model is IUndoableModel))
			{	
				_curentState --;
				model = ((IUndoableModel)(model)).fromAMF(undoStackStorage[_curentState] as ByteArray);
				ByteArray(undoStackStorage[_curentState]).position = 0;
			}
			
		}
		
		public function performRedo():void
		{
			if ( _curentState < undoStackStorage.length -1 && model is Project)
			{
				_curentState ++;
				model = ((IUndoableModel)(model)).fromAMF(undoStackStorage[_curentState] as ByteArray);
				ByteArray(undoStackStorage[_curentState]).position = 0;
			}
		}
		
	}
}