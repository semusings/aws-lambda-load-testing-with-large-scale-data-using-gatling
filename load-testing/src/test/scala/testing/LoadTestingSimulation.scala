package testing

import java.util.UUID.randomUUID
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._

class LoadTestingSimulation extends Simulation {

  private val ENDPOINT = "https://xxxxx.execute-api.ap-southeast-2.amazonaws.com/test"
  private val BODY: String = "{\"customerId\" : \"@@customerId@@\" }"

  /*
      REPETITION -> 2000
      NO_OF_USERS -> 50
      ------------------------
      TOTAL REQUEST -> 100000
   */
  private val scn: ScenarioBuilder = scenario("Load Testing")
    .repeat(2000) {
      exec(
        http("initiation")
          .post(ENDPOINT + "/orders")
          .check(status.is(200))
          .body(StringBody(session => BODY.replaceAll("@@customerId@@", newId)))
          .header("Content-type", "text/xml")
      )
    }

  setUp(scn.inject(atOnceUsers(50))
    .protocols(http
      .baseURL(ENDPOINT)
      .acceptHeader("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
      .acceptEncodingHeader("gzip, deflate")
      .acceptLanguageHeader("en-US,en;q=0.5")
      .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")))

  private def newId = {
    randomUUID().toString.substring(0, 33)
  }

}
