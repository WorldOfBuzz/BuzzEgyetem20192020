package controllers;

import play.mvc.Controller;

public class MyFirstController extends Controller {

    /**
     * Az a szabály, hogy a Controllerbeli metódus:
     * - statikus legyen (static) 
     * - void legyen (nem ad vissza semmit)
     * - Controllerből származó osztályban legyen
     */
	public static void controllerExercise() {
		renderArgs.put("myvariable", "Hello, my variable");
		render("@MyFirstContoller.myfirstview");
	}
}
