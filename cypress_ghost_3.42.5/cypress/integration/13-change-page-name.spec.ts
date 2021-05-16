import { Login } from "../page-objects/login";
import { SideBar } from "../page-objects/side-bar";
import { SettingsPage } from "../page-objects/settings-page";
import * as faker from "faker";
import { should } from "chai";
const login = new Login();
const sideBar = new SideBar();
const settingsPage = new SettingsPage();

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";

describe("Should login and create a post with title succesfully", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  const newTitle = faker.lorem.words();
  let tempURL: string;

  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should login the user", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.url().should("include", "/#/site");
  });

  it("should go to settings", () => {
    if (sideBar.checkIfComponentExists()) {
      cy.log("theres sidebar");
      sideBar.goToGeneralSettings();
    }
  });

  it("should change name of the website", () => {
    settingsPage
      .expandTitleAndDescription()
      .fillNameSite(newTitle)
      .saveSettings();
  });

  it("should go to site", () => {
    sideBar.goToSite();
  });

  it("then it should contain new title", () => {
    cy.contains(newTitle).should("exist");
  });
  
});
