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

  //const postTitle = faker.lorem.words();
  let datetime;
  let postTitle;
  before(() => {
    datetime = new Date().toISOString().replace(/:/g, ".");
    cy.request(
      {
          method : 'GET',
          url : 'https://my.api.mockaroo.com/post_schema.json?key=b843a030',
          headers : {
              'content-type' : 'application/json'
          },
          body : {
              'postTitle' : 'post_naughty'
          }
      }).then((response)  => {
          expect(response).property('status').to.equal(200)
          expect(response.body).property('post_naughty').to.not.be.oneOf([null, ""])
          const body = (response.body)
          postTitle = body['post_naughty']
      });
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
      postPage.clickNewPost();
      cy.screenshot(`${datetime}/image-3`);
      postPage.fillTitle(postTitle).clickBack();
    }
  });

  it("post with random title should be available on post list", () => {
    cy.contains(postTitle).should("exist");
  });

  it("should open search", () => {
    sideBar.goToTags();
    cy.screenshot(`${datetime}/image-4`);
    sideBar.goToSearch();
    cy.screenshot(`${datetime}/image-5`);
  });

  it("Should type search", () => {
    sideBar.typeSearch(postTitle);
  });

  it("Then post should be available in search", () => {
    cy.contains(postTitle).wait(5000);
  });
});
