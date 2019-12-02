package controllers;

import models.Library;
import models.LibraryBook;
import play.mvc.Controller;

public class LibraryBookDeleteController extends Controller{

	public static void deleteBook(Long libraryBookId) {
			LibraryBook book = LibraryBook.findById(libraryBookId);
			
			if (book != null) { //ha nem NULL, akkor létezik
				Library library = book.owningLibrary;
				book.delete(); //DELETE
				LibraryDetailsController.libraryDetails(library.libraryId);
			} else {
				flash.put("errorMessage", "Nem létező könyv!");
				LibraryController.libraryBooks(null);
			}
	}
}
