package component
{
	import spark.components.NavigatorContent;
	
	import net.fproject.di.Injector;
	
	import util.UndoManager;

	public class NewUndoableNavigatorView extends NavigatorContent implements IUndoable
	{
		private var _undoManager:UndoManager;
		
		public function get undoManager():UndoManager
		{
			return UndoManager.getInstanceByViewId("1"); 
		}
		
		public function set model(value:Object ):void
		{
			
		}
		
		/**
		 * Constructor 
		 * 
		 */
		public function NewUndoableNavigatorView()
		{
			Injector.inject(this);
		}
	}
}