package controllers;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import models.Library;
import play.mvc.Controller;

public class LibraryController extends Controller{

	public static void libraryBooks(Long libraryId) {
		/**
		 * Kell az összes könyvtár
		 * Kell az összes könyv belőlük
		 * 
		 * Át kell adni a html-be
		 */
		
		List<Library> libraries = Library.findAll();
		
		/**
		 * a libraryId opcionális paraméter! Lehet üres!
		 */
		if (libraryId == null) {
			for (Library library : libraries) {
				renderArgs.put("libraryBooks"+library.libraryId, library.books);
			}
			
			renderArgs.put("libraries", libraries);
		} else {
			/** KÓD ALAPÚ KERESÉS. NEM JÓ
			Library libraryToShow = null;
			for (Library library : libraries) {
				if (library.libraryId.equals(libraryId)) { //megnézzük egyezik-e
					libraryToShow = library;
				}
			}
			**/
			
			Library libraryToShow = Library.findById(libraryId); // elsődleges kulcs alapján keresünk. Nem kódban, db szinten megy a matek!
			if (libraryToShow != null) { // Ha null NEM maradt, akkor van találat!
				renderArgs.put("libraries", Arrays.asList(libraryToShow));
			} else {
				// nincs találat, nem adunk át semmit.
			}
		}
		
		render("@Application.Library.libraryBooks");
	}
}
