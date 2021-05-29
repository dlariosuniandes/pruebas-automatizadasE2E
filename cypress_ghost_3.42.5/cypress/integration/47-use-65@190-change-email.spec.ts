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
  const user65 = faker.helpers.replaceSymbols("?".repeat(65)).toLowerCase()
  const domain190 = faker.helpers.replaceSymbols("?".repeat(186)).toLowerCase() + ".com"
  const email = user65 + "@" + domain190
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
    profile.fillEmail(email)
    profile.clickSave()
  })

  it("then should mark it as a invalid", () => {
    cy.xpath(`//p[@class="response"]`).should("exist").should("contain", "valid email")
  })

  it("should return mail to normal", () => {
    it("write a non valid email", () => {
      profile.fillEmail(Cypress.env('user'))
      profile.clickSave()
    })
  })
});