import { Login } from "../page-objects/login";
import { SideBar } from "../page-objects/side-bar";
import { PostPage } from "../page-objects/post-page";
import * as faker from "faker";
import { should } from "chai";
const login = new Login();
const sideBar = new SideBar();
const postPage = new PostPage();
let postTitle;
const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";  

describe("Should login and create a post with title succesfully", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

 

  let datetime;
  before(() => {
    datetime = new Date().toISOString().replace(/:/g, ".");
    cy.fixture('post-data-apriori.json').then((data)  => {
      let varPost = data[Math.floor(Math.random() * data.length)];
      postTitle = varPost.post_naughty;
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

  it("should go to posts", () => {
    if (sideBar.checkIfComponentExists()) {
      cy.log("theres sidebar");
      sideBar.goToPosts();
      cy.screenshot(`${datetime}/image-2`);
    }
  });

  it("should create a post with random title", () => {
    if (postPage.checkIfComponentExists()) {
      postPage.clickNewPost().fillTitle(postTitle).clickBack()
      cy.screenshot(`${datetime}/image-3`);
    }
  });

  it("post with random title should be available on post list", () => {
    cy.contains(postTitle).should("exist").wait(5000);
    cy.screenshot(`${datetime}/image-4`);
  });
});
