import { Login } from "../page-objects/login";
import { Profile } from "../page-objects/profile";
import { SideBar } from "../page-objects/side-bar";
import { Staff } from "../page-objects/staff-page";
import * as faker from "faker";

const login = new Login();
const staff = new Staff();
const sideBar = new SideBar();

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";

describe("Will try to login using using a non-email string and a password", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  let datetime;
  let newEmail;
  before(() => {
    datetime = new Date().toISOString().replace(/:/g, ".");
    cy.request(
      "GET",
      "https://my.api.mockaroo.com/login_schema.json?key=872fc0c0"
    ).then((response) => {
      expect(response).property("status").to.equal(200);
      const body = response.body;
      newEmail = body[Math.floor(Math.random() * (body.length -1))];
    });
  });
  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should go to login", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.screenshot(`${datetime}/image-1`);
  });

  it("should go staff", () => {
    sideBar.goToStaff();
  });

  it("should add the duplicate email (owner email)", () => {
    staff.clickInvite();
    cy.log(newEmail)
    staff.fillEmail(newEmail.email);
    staff.clickSend();
  });

  it("then message of non valid email should display", () => {
    cy.xpath(`//p[@class="response"]`).should('have.attr', 'hidden')
  });

  it("should revoke invite", ()=> {
    staff.revokeInvite(newEmail.email)
  })

  it("then revoked user should not appear anymore", ()=> {
    cy.xpath(`h3[text()="${newEmail.email}"]`).should('not.exist')
  })
});
