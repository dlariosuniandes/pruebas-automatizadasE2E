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

  const tagTitle = faker.lorem.word() + " " + faker.lorem.word();

  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should login the user", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.url().should("include", "/#/site");
  });

  it("should go to profile", () => {
    profile.goToProfile();
  });

  it("should change password", () => {
    profile
      .fillOldPassword(Cypress.env("password"))
      .fillNewPassword(Cypress.env("password"))
      .fillVerifyNewPassword()
      .clickChangePassword();
  });

  it("then password should be updated succesfully", ()=>{
      cy.contains('Password updated.')
  })

});