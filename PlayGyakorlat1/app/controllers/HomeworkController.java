package controllers;

import java.text.SimpleDateFormat;
import java.util.Date;

import play.mvc.Controller;

public class HomeworkController extends Controller{
	
	/**
	 * JAvaban a static final a konstans
	 */
	private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd-MM-yyyy HH:mm");

	public static void homework(String input1, String input2) {
		/**
		 * a, b --> ab
		 */
		String concatenatedString = input1 + input2;
		renderArgs.put("mystring", concatenatedString);
		
		renderArgs.put("dateToOutput", DATE_FORMAT.format(new Date()));
		/**
		 * a html fájl elérési útja a views/ könyvtáron belül, .html kiterjesztés nélkül
		 */
		render("@Application.homework");
	}
}
