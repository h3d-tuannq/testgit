package util
{
	import flash.utils.ByteArray;
	
	import flashx.undo.UndoManager;
	
	import interfaces.IUndoModel;
	
	import net.projeckit.model.ProjectModel;
	
	
	//[PropertyBinding(hostChain="_model", targetField="undoManager.model")]
	//[PropertyBinding(hostChain="TaskModule._model", targetField="@model@")]
	public class UndoManager extends flashx.undo.UndoManager
	{
		private static var _instances:Object = {};
		//Dat ten lai la: undoStackStorage
		
		private var undoStackStorage:Vector.<Object> = new Vector.<Object>;
		
		
		private var undoCollectionStackStorage:Vector.<Object> = new Vector.<Object>;
		
		[Bindable]
		public var model:IUndoModel;
		
		[Bindable]
		public var colection:Object;
		
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
			 if ( model is IUndoModel){
				 
				var dataByteArray:ByteArray = ((IUndoModel)(model)).tryToAMF(); 
				
			 	var collectionByteArray:ByteArray = CollectionChangeManagerTest.getInstance().tryToAMF((model as ProjectModel).taskCollection);
			 }
			 if (dataByteArray != null){
				 _curentState++;
				 undoStackStorage.splice(_curentState,undoStackStorage.length - _curentState,dataByteArray);
				 undoCollectionStackStorage.splice(_curentState,undoCollectionStackStorage.length - _curentState,collectionByteArray);
				 
			 }	 
		}
		
		public function performUndo():void
		{
			
			if ((_curentState>0) && (model is IUndoModel))
			{	
				_curentState --;
				model = ((IUndoModel)(model)).tryFromAMF(undoStackStorage[_curentState] as ByteArray);
				colection = CollectionChangeManagerTest.getInstance().tryFromAMF(undoCollectionStackStorage[_curentState] as ByteArray);
				ByteArray(undoStackStorage[_curentState]).position = 0;
				ByteArray(undoCollectionStackStorage[_curentState]).position = 0;
				//CollectionChangeManagerTest.getInstance().setCollection((model as ProjectModel).taskCollection,colection);
			}
			
		}
		
		public function removeTopUndoStore():void
		{
			if(undoStackStorage.length <1)
				return;
			var obj:Object = undoStackStorage.pop();
			return;
		}
		
		public function isFirstModel():Boolean
		{
			return undoStackStorage.length == 0;	
		}
		
		public function performRedo():void
		{
			if ( _curentState < undoStackStorage.length -1 && model is IUndoModel)
			{
				_curentState ++;
				model = ((IUndoModel)(model)).tryFromAMF(undoStackStorage[_curentState] as ByteArray);
				colection = CollectionChangeManagerTest.getInstance().tryFromAMF(undoCollectionStackStorage[_curentState]as ByteArray);
				ByteArray(undoStackStorage[_curentState]).position = 0;
				ByteArray(undoCollectionStackStorage[_curentState]).position = 0;
				//CollectionChangeManagerTest.getInstance().setCollection((model as ProjectModel).taskCollection,colection);
			}
		}
		
	}
}