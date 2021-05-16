import { Login } from "../page-objects/login";
import { SideBar } from "../page-objects/side-bar";
import { CodeInjection } from "../page-objects/code-injection";
import * as faker from "faker";
import { should } from "chai";
const login = new Login();
const sideBar = new SideBar();
const codeInjection = new CodeInjection();

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";

describe("Should login and create a post with title succesfully", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  const codeInjectionText = faker.lorem.word();

  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should login the user", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.url().should("include", "/#/site");
  });

  it("should go to code Injection", () => {
    sideBar.goToCodeInjectionSite();
  });

  it("should inject the code", () => {
    codeInjection.addHeader(codeInjectionText).saveChanges();
  });

  it("should go to site", () => {
    sideBar.goToSite();
  });

  it("then the code injected should exist in DOM", () => {
    cy.visit(Cypress.env('url'));
    cy.get(`.${codeInjectionText}`, { timeout: 10000 }).should("exist");
  });
});
