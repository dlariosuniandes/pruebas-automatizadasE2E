import { Login } from "../page-objects/login";
import { SideBar } from "../page-objects/side-bar";
import { PagePage } from "../page-objects/page-page";
import * as faker from "faker";

const login = new Login();
const sideBar = new SideBar();
const pagePage = new PagePage();
let pageTitle;

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";  

describe("Should login and create a page with title succesfully", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  
  let datetime;
  before(() => {
    datetime = new Date().toISOString().replace(/:/g, ".");
    cy.fixture('page-data-apriori.json').then((data)  => {
      let varTag = data[Math.floor(Math.random() * data.length)];
      pageTitle = varTag.page_1999;
      console.log(pageTitle)
    })
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
    cy.contains("Are you sure you want to leave this page?").should("exist").wait(10000);
  });
});