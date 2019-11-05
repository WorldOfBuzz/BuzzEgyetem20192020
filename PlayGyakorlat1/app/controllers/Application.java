package controllers;

import play.*;
import play.mvc.*;

import java.util.*;

import models.*;

public class Application extends Controller {

    public static void index_test() {
        render();
    }

    /**
     * Az a szabály, hogy a Controllerbeli metódus:
     * - statikus legyen (static) 
     * - void legyen (nem ad vissza semmit)
     * - Controllerből származó osztályban legyen
     */
    public static void dummyPage1() {
    	render();
    }
}