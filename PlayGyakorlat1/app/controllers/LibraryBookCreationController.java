package controllers;

import java.util.List;

import models.Library;
import models.LibraryBook;
import play.data.validation.Required;
import play.data.validation.Validation;
import play.mvc.Before;
import play.mvc.Controller;

public class LibraryBookCreationController extends Controller{
	
	/**
	 * Ez a @Before azt jelenti, hogy minden Controllerbeli metódus előtt lefut.
	 * 
	 */
	@Before
	public static void prepareBookCreationPage() {
		List<Library> libraries = Library.findAll();
		//átadom a listát, hogy a template kódban is tudjam használni a template kigenerálásakor
		renderArgs.put("libraries", libraries);
	}

	public static void createLibraryBookForm() {
		List<Library> libraries = (List<Library>) renderArgs.get("libraries");
		if (libraries.size() == 0) {
			//itt hiba van, nincs könyvtár
			flash.put("errorMessage", "Nincsenek könyvtárak!");
			LibraryController.libraryBooks(null);
		} else {
			//minden rendben, van könyvtár, tudunk létrehozni könyvet
			render("@Application.Library.createLibraryBook");
		}
	}
	
	/**
	 * Megfeleltettük a HTML form inputjait a java-s metódus bemenő paramétereinek. 
	 */
	public static void createLibraryBook( @Required(message="A könyvtár kiválasztása!") Long libraryId, 
										  @Required(message="Az EAN kitöltése kötelező!") String ean, 
										  @Required(message="A szerző kitöltése kötelező!") String author, 
										  @Required(message="A cím kitöltése kötelező!") String title, 
										  @Required(message="Az oldalszám kitöltése kötelező!") Integer pageNumber, 
											Boolean isRaktaron  ) {
		
		if (ean != null) {
			ean = ean.trim(); //whitespace-ek levágja a string elejéről / végéről
		}
		
		boolean isInvalid = isInvalidCreateLibraryBookRequest(validation, libraryId, ean, pageNumber);
		
		if (isInvalid) {
			//hiba volt validálás során
			params.flash(); 
			render("@Application.Library.createLibraryBook");
		} else {
			//hozzuk létre a könyvet
			
			LibraryBook book = new LibraryBook();
			book.owningLibrary = Library.findById(libraryId);
			book.ean = ean;
			book.title = title;
			book.author = author;
			book.pageNumber = pageNumber;
			
			/**
			 * A ? előtti rész a feltétel. Ha ez TRUE, akkor a ? és : közti részt állítjuk be
			 * Különben a : utáni részt.
			 * 
			 * Ez azért kell, mert az isRaktaron egy checkbox típusú input, ami ha nincs bepipálva, nem 
			 * is küldi fel a böngésző a szerverre minden esetben, ezért lehet, hogy NULL lesz ez az érték
			 */
			book.isRaktaron = isRaktaron == null ? false : isRaktaron;
			
			book.save();
			
			LibraryDetailsController.libraryDetails(libraryId);
		}
		
	}
	
	public static boolean isInvalidCreateLibraryBookRequest(Validation validation, Long libraryId, String ean, Integer pageNumber) {
		
		// A kapott libraryIdhoz tartozó Library valóban létezik
		Library library = Library.findById(libraryId);
		if (library == null) {
			//ha ez igaz, akkor nem létezik 
			validation.addError("libraryId", "A kiválasztott könyvtár már nem létezik!");
		}
		
		//EAN: 978cal kezdődik && 13 karakter hosszú
		if (ean != null) {
			
			if (!ean.startsWith("978")) { // ha NEM 978-cal kezdődik a (! a negálás)
				validation.addError("ean", "Az EAN könyvek esetén 978-cal kezdődik!");
			}
			
			if (ean.length() != 13) {
				validation.addError("ean", "Az EAN hossza pontosan 13 karakter kell legyen!");
			}
		}
		
		// az oldalszám létezik és pozitív szám, akkor jó, egyéb esetben errorunk van
		if (pageNumber != null && pageNumber <= 0){ 
			validation.addError("pageNumber", "Az oldalszám pozitív szám kell legyen!");
		}
		
		//ha történt addError hívás, akkor ez TRUE lesz, ha nem, akkor FALSE
		return validation.hasErrors();
	}
}
