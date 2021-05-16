import { Login } from "../page-objects/login";
import { SideBar } from "../page-objects/side-bar";
import { TagPage } from "../page-objects/tag-page";
import * as faker from "faker";

const login = new Login();
const sideBar = new SideBar();
const tagPage = new TagPage();

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";

describe("Should login and create a tag with name successfully", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  const tagTitle = faker.lorem.word() + " " + faker.lorem.word();
  const newTagTitle = faker.lorem.word() + " " + faker.lorem.word();

  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should login the user", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.url().should("include", "/#/site");
  });

  it("should go to tags", () => {
    if (sideBar.checkIfComponentExists()) {
      cy.log("theres sidebar");
      sideBar.goToTags();
    }
  });

  it("should create a tag with random title", () => {
    if (tagPage.checkIfComponentExists()) {
      tagPage.clickNewTag().fillTagName(tagTitle).saveTag().clickBack();
    }
  });

  it("tag with random title should be available on post list", () => {
    cy.contains(tagTitle).should("exist");
  });

  it("will enter on created tag", () => {
    cy.contains(tagTitle).click({ force: true });
  });

  it("should modify the title", () => {
    tagPage.fillTagName(newTagTitle).saveTag().clickBack()
  });

  it("page with new title shoould exist", () => {
    cy.contains(newTagTitle).should("exist");
  });
});