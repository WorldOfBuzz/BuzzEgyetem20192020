package controllers;

import models.Library;
import play.data.validation.Required;
import play.mvc.Controller;

public class LibraryDetailsController extends Controller {

	public static void libraryDetails(@Required(message="Azonosító szükséges") 
											Long libraryId){
		Library library = null;
		
		if (libraryId != null){
			library = Library.findById(libraryId);
		}
		
		if (library == null){ //ha nem létezik, akkor csak visszadobjuk a főoldalra a usert
			LibraryController.libraryBooks(null);
		} else {
			renderArgs.put("library", library);
			render("@Application.Library.libraryDetails");
		}
	}
}
