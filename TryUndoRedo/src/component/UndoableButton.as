package component
{
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	
	
	import util.UndoManager;
	

	public class UndoableButton extends Button
	{
		
		public function get undoManager():UndoManager
		{
			return _activeView == null? null : _activeView.undoManager;
		}
		
		
		private var _activeView:IUndoable;
		
		[Bindable("propertyChange")]
		/**
		 * The current active UI view that uses this button.
		 * */
		public function get activeView():IUndoable
		{
			return _activeView;
		}
		
		public function set activeView(value:IUndoable):void
		{
			if(_activeView !== value)
			{
				/*var oldValue:IUndoable = _activeView;
				_activeView = value;
				dispatchPropertyChangeEvent("activeView", activeView, value);*/
				_activeView = value;
			}
		}
		
		public var actionFunction:Function;
		public var executeOrder:String = calculateOperationBefore;
		
		public static var calculateOperationBefore:String = "before";
		public static var calculateOperationAfter:String = "after";
		
		public function UndoableButton()
		{
			this.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			/*if((actionFunction != null) && (executeOrder == calculateOperationAfter))
				this.actionFunction(event);*/
			
				
			if(undoManager.isFirstModel()) 
				undoManager.recordChange();
			if(actionFunction != null)
				this.actionFunction(event);
			undoManager.recordChange();
		/*	if((actionFunction != null) && (executeOrder == calculateOperationBefore))
				this.actionFunction(event);*/
		}
		
		public static function attachUndoableButton(container:Object, undoButton:component.UndoableButton, containerClass:Class):void
		{
		/*	var infoMember:Object =
				ReflectionUtil.findMemberMetadataValue(containerClass, undoButton, UNDO_HANDLING);
			if(infoMember != null)
			{
				var info:Object = container[infoMember];
				undoButton.handlers = info;
			}	*/		
		}
		
	}
}