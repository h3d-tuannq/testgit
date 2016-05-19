package net.projeckit.model
{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import interfaces.IUndoModel;
	
	import net.projectkit.model.Project;
	import net.projectkit.model.Task;
	import net.projectkit.model.handler.ProjectHandler;
	
	public class ProjectModel extends Project implements IUndoModel
	{
		public function ProjectModel()
		{
			
			super();
		}
		
		public function setUpTestTask(arr:Array = null):void{
			this.projectTasks = arr;
		}
		
		public function getProjectTask():ArrayCollection{
			return this.taskCollection;
		}
		
		public function tryToAMF():ByteArray{
			return this.toAMF();
		}
		
		
		public function tryFromAMF(amf:ByteArray):Object{
			//return (this.fromAMF(amf) as net.projeckit.model.ProjectModel) ;
			
			var p:ProjectModel = new ProjectModel();
			var o:Object = amf.readObject();
			for(var fieldName:String in o)
			{
				if (fieldName != "taskIdToParent")
					p[fieldName] = o[fieldName];
			}
			
			for each(var t:Task in p.projectTasks)
			{
				t.parent = o.taskIdToParent[t.id];
			}
			
			ProjectHandler.getInstance().start(p);
			return p;
			
			//var pm:ProjectModel = ProjectModel(this.fromAMF(amf));
			//return pm;
		}
	}
}