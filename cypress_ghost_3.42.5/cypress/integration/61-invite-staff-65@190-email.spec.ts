import { Login } from "../page-objects-daniel/login";
import { Profile } from "../page-objects-daniel/profile";
import { SideBar } from "../page-objects-daniel/side-bar";
import { Staff } from "../page-objects-daniel/staff-page";
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

  faker.seed(123)
  const user65 = faker.helpers.replaceSymbols("?".repeat(65)).toLowerCase()
  const domain190 = faker.helpers.replaceSymbols("?".repeat(186)).toLowerCase() + ".com"
  const email = user65 + "@" + domain190


  let datetime;
  before(() => {
    datetime = new Date().toISOString().replace(/:/g, ".");
  });
  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should go to login", () => {
    login.visit();
    login.loginWithEnvUser()
    cy.screenshot(`${datetime}/image-1`);
  });

  it("should go staff", () => {
    sideBar.goToStaff()
  })

  it("should add the 65@190email",()=> {
    staff.clickInvite()
    staff.fillEmail(email)
    staff.clickSend()
  })

  it("Then Should not show any warning and send the email",()=> {
    cy.xpath(`//p[@class="response"]`).should('contain', 'Invalid')
  })

});