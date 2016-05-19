package viewTest
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	
	import spark.components.DataGrid;
	
	import component.NewUndoableNavigatorView;
	import component.UndoableButton;
	
	import interfaces.IUndoModel;
	
	import net.projeckit.model.ProjectModel;
	import net.projectkit.model.Task;
	
	import util.CollectionChangeManagerTest;
	
	[PropertyBinding(hostChain="undoManager.model", targetField="_model")]
	public class TaskModule extends NewUndoableNavigatorView
	{   
		[Bindable]
		public var _model:ProjectModel;
		
		
		/*[Bindable]
		[PropertyBinding(model = "_model")]
		public var undoManager:UndoManager;*/
		
		
		public function TaskModule()
			
		{
			super();
			
			/*newTask.activeView = this;
			deleteButton.activeView = this;*/
		}
		
		public function setModel(value:IUndoModel):void
		{
			if(value is ProjectModel){
				this._model = value as ProjectModel;
				listTask.dataProvider = _model.taskCollection;
				undoManager.model = _model;
				registerColection(_model);
				
			}
			
		}
		
		public function helpButton_click(event:Event):void
		{
			Alert.show("quantuan");
		}
		
		public var calculateOperationBefore:String = UndoableButton.calculateOperationBefore;
		public var calculateOperationAfter:String = UndoableButton.calculateOperationAfter;
		
		public function addButton_click(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var tmp:Task  = new Task();
			tmp.name = "new task";
			tmp.id = "t"+(listTask.dataProviderLength + 1).toString(10);
			_model.taskCollection.addItem(tmp);
			undoManager.model = _model;
		}
		
		
		public function get collectionChangeManager():CollectionChangeManagerTest
		{
			return CollectionChangeManagerTest.getInstance();
		}
		
		public function registerColection(value:ProjectModel):void
		{
			collectionChangeManager.registerCollection(value.taskCollection);
			if(undoManager.colection != null)
				collectionChangeManager.setCollection(value.taskCollection,undoManager.colection);
		}
		
		public function deleteButton_click(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(listTask.selectedIndex > -1)
				_model.taskCollection.removeItemAt(listTask.selectedIndex);	
		}
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(dataProvider = "undoManager.model.taskCollection")]
		public var listTask:DataGrid;
		
		[SkinPart(required="true",type="static")]
		/*[EventHandling(event="flash.events.MouseEvent.CLICK",handler="addButton_click")]*/
		[PropertyBinding(actionFunction="addButton_click")]
		//[PropertyBinding(executeOrder = "calculateOperationAfter")]
		public var newTask:UndoableButton;
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="flash.events.MouseEvent.CLICK",handler="deleteButton_click")]
		
		public var deleteButton:UndoableButton;
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance is component.UndoableButton)
			{
				component.UndoableButton.attachUndoableButton(this, component.UndoableButton(instance), TaskModule);
				component.UndoableButton(instance).activeView = this;
				undoableButtons.push(instance);
			}
		}
		
		private var undoableButtons:Array = [];
	}
}