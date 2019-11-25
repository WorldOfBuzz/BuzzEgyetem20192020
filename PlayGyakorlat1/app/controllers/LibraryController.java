package controllers;

import java.util.Arrays;
import java.util.List;
import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import models.Library;
import models.LibraryBook;
import play.mvc.Controller;

public class LibraryController extends Controller{
	
	/**
	 * Random könyvtárak neveit vesszük majd ebből a listából
	 */
	private static final List<String> LIBRARY_NAMES = 
				Arrays.asList("Petőti Sándor","Széchenyi István", "Városi Könyvtár",
							  "KOssuth Lajos","Nemzeti Könyvtár");
	
	/**
	 * static final = KONSTANS
	 */
	private static final Logger LOGGER = Logger.getLogger(LibraryController.class);

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
				for (LibraryBook book : library.books) {
					if (!book.isRaktaron) { // ! a negálás
						LOGGER.warn("A könyv nincs raktáron: " + book.ean);
					}
				}
				/**
				 * Ez most nem is szükséges. :)
				 */
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
	
	public static void addRandomLibrary() {
		Random randomGenerator = new Random();
		
		/**
		 * Random számot generálunk, amit a lista hossza határoz meg 
		 * 
		 * Azért csináljuk így, mert így volt a leggyorsabb véletlenszerű adatot generálni.
		 */
		int randomIndex = randomGenerator.nextInt(LIBRARY_NAMES.size());
		/**
		 * A random index használatával kiszedem a könyvtár nevét
		 */
		String randomLibraryName = LIBRARY_NAMES.get(randomIndex);
		
		/**
		 * Lekérdezzük az adatbázisból, hogy ezen a néven van-e már könyvtár
		 */
		Library library = Library.find(" libraryName = ? ", randomLibraryName).first();
		
		if (library == null) { //ha nincs ilyen könyvtár, újat hozunk létre
			library = new Library();
			library.libraryName = randomLibraryName;
		} else { //ha vna ilyen könyvtár, akkor csak átállítjuk
		}
		
		/**
		 * nextInt(n) az [0,n)
		 * 
		 * n = 9000 esetén 0 és 8999 közé eshet a visszadott szám
		 */
		library.libraryPostcode = randomGenerator.nextInt(9000) + 1000;
		
		library.save();
		
		/**
		 * átirányítás a GET /libraryBooks hívásra, paraméter nélkül
		 */
		libraryBooks(null);
	}
	
	public static void addRandomLibraryBook() {
		Random random = new Random();
		Library randomLibrary = selectRandomLibrary();
		
		if (randomLibrary != null) {
			LibraryBook libraryBook = new LibraryBook();
			libraryBook.owningLibrary = randomLibrary;
			
			String randomEanIntegerAsStr = new Integer(random.nextInt(9999999)).toString();
			libraryBook.ean = StringUtils.leftPad(randomEanIntegerAsStr, 13, '9'); //13 hosszú, balról 9es karakterrel kiegészített kamu-vonalkkód
			libraryBook.isRaktaron = random.nextInt(10) % 2 == 0; //ha páros a random, raktáron lesz
			libraryBook.pageNumber = random.nextInt(500) + 100; // 100 és 600 között generálunk
			libraryBook.title = RandomStringUtils.random(30, true, false);  //random string , semmi értelme nem lesz!
			libraryBook.author = RandomStringUtils.random(30, true, false); //random string, semmi értelme nem lesz!

			libraryBook.save();
		}
		
		/**
		 * átirányítás a GET /libraryBooks hívásra, paraméter nélkül
		 */
		libraryBooks(null); 
	}
	
	public static void deleteRandomLibrary() {
		Library randomLibrary = selectRandomLibrary();
		
		if (randomLibrary != null) {
			/**
			 * Először töröljük az összes könyvet
			 */
			for (LibraryBook book : randomLibrary.books) {
				book.delete();
			}
			/**
			 * most töröljük a könyvtárat
			 */
			randomLibrary.delete();
		}
		
		/**
		 * átirányítás a GET /libraryBooks hívásra, paraméter nélkül
		 */
		libraryBooks(null); 
	}
	
	private static Library selectRandomLibrary(){
		List<Library> libraries = Library.findAll();
		Library library = null;
		if (libraries.size() > 0){
			Random random = new Random();
			/**
			 * Ugyanaz a logika, mint a könyvtár neve választásakor.
			 * Listából random index alapján választás
			 */
			int randomIndex = random.nextInt(libraries.size());
			library = libraries.get(randomIndex);
		}
		return library;
	}
}
