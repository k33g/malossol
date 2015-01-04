package acme;

import java.lang.String;
import java.lang.System;

public class Toon implements iToon {

  public String name;

  public String getName() {
    return this.name;
  }

  public iToon setName(String value) {
    this.name = value;
    return this;
  }  

  public Toon(String name) {
    this.name = name;
  }

  public Toon() {
    this.name = "Toon Doe";
  }

  public String hello(String message) {
    return "[" + this.name + "]:" + message;
  }

  public String yo() {
    return "yo!!!";
  }

  public String hug(Toon toon) {
    return "I <3 " + toon.getName();
  }

  public static Toon getInstance(String name) {
    return new Toon(name);
  }

}