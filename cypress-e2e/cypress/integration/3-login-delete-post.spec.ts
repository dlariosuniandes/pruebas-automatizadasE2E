import { Login } from "../page-objects/login";
import { SideBar } from "../page-objects/side-bar";
import { PostPage } from "../page-objects/post-page";
import * as faker from "faker";
import { should } from "chai";
const login = new Login();
const sideBar = new SideBar();
const postPage = new PostPage();

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";  

describe("Should login and create a post with title succesfully", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  const postTitle = faker.lorem.words()

  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should login the user", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.url().should("include", "/#/site");
  });

  it("should go to posts", () => {
    if (sideBar.checkIfComponentExists()) {
      cy.log("theres sidebar");
      sideBar.goToPosts();
    }
  });

  it("should create a post with random title", () => {
    if (postPage.checkIfComponentExists()) {
      postPage.clickNewPost().fillTitle(postTitle).clickBack()
    }
  });

  it("post with random title should be available on post list", () => {
    cy.contains(postTitle).should("exist")
  });

  it("will enter on created post", () => {
      cy.contains(postTitle).click({force: true})
  })

  it("post is deleted", () => {
      postPage.clickDelete().confirmDelete()
  })

  it("post should not exist anymore", () => {
    cy.contains(postTitle).should("not.exist")
})
});