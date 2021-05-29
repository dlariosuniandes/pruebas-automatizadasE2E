import { Login } from "../page-objects-daniel/login";
import { Profile } from "../page-objects-daniel/profile";
import { SideBar } from "../page-objects-daniel/side-bar";
import * as faker from "faker";

const login = new Login();
const profile = new Profile();
const sideBar = new SideBar();

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";

describe("Will try to login using using a non-email string and a password", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  faker.seed(123);
  const spacePassword = " ";

  let datetime;
  before(() => {
    datetime = new Date().toISOString().replace(/:/g, ".");
  });
  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should go to login", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.screenshot(`${datetime}/image-1`);
  });

  it("should go to profile page", () => {
    profile.goToProfile();
  });

  it("write a non valid email", () => {
    profile.fillOldPassword(Cypress.env("password"));
    profile.fillNewPassword(spacePassword);
    profile.fillVerifyNewPassword();
    cy.log(spacePassword);
    profile.clickChangePassword();
  });

  it("it should not trigger any warm", () => {
    cy.xpath(`//p[@class="response"]`).should("contain", "be blank");
  });
});
