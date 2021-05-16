import { Login } from "../page-objects/login";
import { SideBar } from "../page-objects/side-bar";
import { Profile } from "../page-objects/profile";
import * as faker from "faker";
import { test } from "mocha";

const login = new Login();
const sideBar = new SideBar();
const profile = new Profile();

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";

describe("Should login and create a tag with name successfully", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  let datetime;
  before(() => {
    datetime = new Date().toISOString().replace(/:/g, ".");
  });

  const testPassword = "uniandestest123";
  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should login the user", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.url().should("include", "/#/site");
    cy.screenshot(`${datetime}/image-1`);
  });

  it("should go to profile", () => {
    profile.goToProfile();
    cy.screenshot(`${datetime}/image-2`);
  });

  it("should change password", () => {
    profile
      .fillOldPassword(Cypress.env("password"))
      .fillNewPassword(testPassword)
      .fillVerifyNewPassword()
      .clickChangePassword();
      cy.screenshot(`${datetime}/image-3`);
  });

  it("should signout", () => {
      profile.clickSignOut()
      cy.screenshot(`${datetime}/image-4`);
  })

  it("should login with the new password", () => {
    login.visit();
    login.loginWithNewPassword(testPassword);
    cy.url().should("include", "/#/site");
  });

  it("should go to profile", () => {
    profile.goToProfile();
  });
  
  it("should change password", () => {
    profile
      .fillOldPassword(testPassword)
      .fillNewPassword(Cypress.env("password"))
      .fillVerifyNewPassword()
      .clickChangePassword();
  });

});
