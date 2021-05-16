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

  it("should go to tags", () => {
    if (sideBar.checkIfComponentExists()) {
      cy.log("theres sidebar");
      sideBar.goToTags();
      cy.screenshot(`${datetime}/image-2`);
    }
  });

  it("should create a tag with random title", () => {
    if (tagPage.checkIfComponentExists()) {
      tagPage.clickNewTag()
      cy.screenshot(`${datetime}/image-2`);
      tagPage.fillTagName(tagTitle).saveTag().clickBack();
    }
  });

  it("tag with random title should be available on post list", () => {
    cy.contains(tagTitle).should("exist");
  });

  it("should open search", () => {
    sideBar.goToPosts();
    cy.screenshot(`${datetime}/image-3`);
    sideBar.goToSearch();
    cy.screenshot(`${datetime}/image-4`);
  });

  it("Should type search", () => {
    sideBar.typeSearch(tagTitle);
  });

  it("Then post should be available in search", () => {
    cy.contains(tagTitle);
  });
});
