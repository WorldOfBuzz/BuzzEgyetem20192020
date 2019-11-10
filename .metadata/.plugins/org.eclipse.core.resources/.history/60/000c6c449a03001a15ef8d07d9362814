package controllers;

import java.util.List;

import models.Library;
import play.mvc.Controller;

public class LibraryController extends Controller{

	public static void libraryBooks() {
		/**
		 * Kell az összes könyvtár
		 * Kell az összes könyv belőlük
		 * 
		 * Át kell adni a html-be
		 */
		
		List<Library> libraries = Library.findAll();
		for (Library library : libraries) {
			renderArgs.put("libraryBooks"+library.libraryId, library.books);
		}
		
		renderArgs.put("libraries", libraries);
	}
}
