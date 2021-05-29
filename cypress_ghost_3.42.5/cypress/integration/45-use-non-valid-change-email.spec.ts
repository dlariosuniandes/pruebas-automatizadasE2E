import { Login } from "../page-objects-daniel/login";
import { Profile } from "../page-objects-daniel/profile";
import * as faker from "faker";

const login = new Login();
const profile = new Profile();


const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";  

describe("Will try to login using using a non-email string and a password", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  faker.seed(123)
  const user64 = faker.helpers.replaceSymbols("?".repeat(64)).toLowerCase()
  const domain191 = faker.helpers.replaceSymbols("?".repeat(187)).toLowerCase() + ".com"
  const email = user64 + "@" + domain191
  const password = faker.lorem.word()

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

  it("should go to profile page", () => {
    profile.goToProfile()
  })

  it("write a non valid email", () => {
    profile.fillEmail(password)
    profile.clickSave()
  })

  it("then should mark it as a invalid", () => {
    cy.xpath(`//p[@class="response"]`).should('contain',"valid email address")
  })

});