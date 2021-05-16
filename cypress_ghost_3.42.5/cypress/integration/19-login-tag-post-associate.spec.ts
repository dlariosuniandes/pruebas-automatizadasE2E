import { Login } from "../page-objects/login";
import { SideBar } from "../page-objects/side-bar";
import { TagPage } from "../page-objects/tag-page";
import * as faker from "faker";
import { PostPage } from "../page-objects/post-page";

const login = new Login();
const sideBar = new SideBar();
const tagPage = new TagPage();
const postPage = new PostPage();

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";

describe("Should login and create a tag with name successfully", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  const tagTitle = faker.lorem.word() + " " + faker.lorem.word();
  const postTitle = faker.lorem.words();

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
      cy.screenshot(`${datetime}/image-3`);
      tagPage.fillTagName(tagTitle).saveTag().clickBack();
    }
  });

  it("tag with random title should be available on tag list", () => {
    cy.contains(tagTitle).should("exist");
  });

  it("should go to posts", () => {
    cy.log("theres sidebar");
    sideBar.goToPosts();
    cy.screenshot(`${datetime}/image-4`);
  });

  it("should create a post with random title", () => {
    postPage.clickNewPost()
    cy.screenshot(`${datetime}/image-5`);
    postPage.fillTitle(postTitle).clickBack();
  });

  it("should select tag", () => {
    cy.contains(postTitle).click({ force: true });
    postPage.goToPostSettings()
    cy.screenshot(`${datetime}/image-6`);
    postPage.selectTag(tagTitle).clickBack().confirmLeave();
  });

  it("post with random title should be available on post list cotaining the tag selected", () => {
    cy.contains(tagTitle).should("exist");
  });
});