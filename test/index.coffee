import { test, success } from "@dashkite/amen"
import assert from "@dashkite/assert"
import print from "@dashkite/amen-console"

# MUT
import { decorator } from "../src"

import api from "./api"
import policies from "./policies"

# mock fetch that just runs locally
globalThis.Sky =
  fetch: decorator policies, ( request ) -> 
    description: "ok"
    content: api

# we would usually pass in another handler,
# but for test purposes we just skip ahead
# to our mock fetch

do ->

  print await test "Enchant Decorator", ->
    response = await Sky.fetch
      domain: "acme.io"
      resource: name: "description"
      method: "get"

    assert.equal "rune", do ->
     response.content.resources
      .foo.methods.get.signatures
      .request.authorization[0]

    assert ! do ->
     response.content.resources
      .bar.methods.get.signatures
      .request.authorization?

  process.exit success