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

  const pageTitle = faker.lorem.words()
  let datetime;
  before(() => {
    datetime = new Date().toISOString().replace(/:/g, ".");
  });

  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should login the user", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.url().should("include", "/#/site");
    cy.screenshot(`${datetime}/image-1`);
  });

  it("should go to pages", () => {
    if (sideBar.checkIfComponentExists()) {
      cy.log("theres sidebar");
      sideBar.goToPages();
      cy.screenshot(`${datetime}/image-2`);
    }
  });

  it("should create a page with random title", () => {
    if (pagePage.checkIfComponentExists()) {
        pagePage.clickNewPost()
        cy.screenshot(`${datetime}/image-3`);
        pagePage.fillTitle(pageTitle).clickBack()
    }
  });

  it("page with random title should be available on post list", () => {
    cy.contains(pageTitle).should("exist")
  });

  it("should open search", () => {
    sideBar.goToPosts();
    cy.screenshot(`${datetime}/image-4`);
    sideBar.goToSearch()
    cy.screenshot(`${datetime}/image-5`);
})

it("Should type search", () => {
   sideBar.typeSearch(pageTitle);
});

it("Then post should be available in search", ()=> {
    cy.contains(pageTitle)
})

});