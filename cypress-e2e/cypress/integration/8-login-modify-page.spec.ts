import { Login } from "../page-objects/login";
import { SideBar } from "../page-objects/side-bar";
import { PagePage } from "../page-objects/page-page";
import * as faker from "faker";

const login = new Login();
const sideBar = new SideBar();
const pagePage = new PagePage();

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";

describe("Should login and create a page with title succesfully", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  const pageTitle = faker.lorem.words();
  const newPageTitle = faker.lorem.words();

  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should login the user", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.url().should("include", "/#/site");
  });

  it("should go to pages", () => {
    if (sideBar.checkIfComponentExists()) {
      cy.log("theres sidebar");
      sideBar.goToPages();
    }
  });

  it("should create a page with random title", () => {
    if (pagePage.checkIfComponentExists()) {
      pagePage.clickNewPost().fillTitle(pageTitle).clickBack();
    }
  });

  it("page with random title should be available on page list", () => {
    cy.contains(pageTitle).should("exist");
  });

  it("will enter on created page", () => {
    cy.contains(pageTitle).click({ force: true });
  });

  it("should modify the title", () => {
    pagePage.fillTitle(newPageTitle).clickBack()
  });

  it("page with new title shoould exist", () => {
    cy.contains(newPageTitle).should("exist");
  });
});