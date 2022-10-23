local EventEmitter = require("mru.event_emitter")

describe("EventEmitter", function()
  it("calls registered function on emit", function()
    local e = EventEmitter()

    local called = false

    e.on("foo", function()
      called = true
    end)

    e.emit("foo")

    assert(called, "Emitter should have been called")
  end)
  it("calls multiple functions on emit", function()
    local e = EventEmitter()

    local called = 0

    e.add_listener("foo", function()
      called = called + 1
    end)

    e.add_listener("foo", function()
      called = called + 2
    end)

    e.emit("foo")

    assert.same(3, called)
  end)
  it("only calls the appropriate function on emit", function()
    local e = EventEmitter()

    local called = 0

    e.add_listener("foo", function()
      called = called + 1
    end)

    e.add_listener("bar", function()
      called = called + 2
    end)

    e.emit("foo")

    assert.same(1, called)
  end)
  it("removes a listener on remove_listener", function()
    local e = EventEmitter()

    local called = 0

    local my_listener = function()
      error("Should not be called")
    end

    e.add_listener("foo", my_listener)

    e.remove_listener("foo", my_listener)

    e.emit("foo")

    assert.same(0, called)
  end)
  it("does not remove all  listener on remove_listener", function()
    local e = EventEmitter()

    local called = 0

    local my_listener = function()
      error("Should not be called")
    end

    e.add_listener("foo", my_listener)
    e.add_listener("foo", function()
      called = called + 1
    end)

    e.remove_listener("foo", my_listener)

    e.emit("foo")

    assert.same(1, called)
  end)
  it("removes all event listeners on remove_all_listeners", function()
    local e = EventEmitter()

    local called = 0

    e.add_listener("foo", function()
      called = called + 1
    end)
    e.add_listener("foo", function()
      called = called + 1
    end)
    e.add_listener("bar", function()
      called = called + 1
    end)

    e.remove_all_listeners()

    e.emit("foo")
    e.emit("bar")

    assert.same(0, called)
  end)
  it("removes all event listeners for specific event on remove_all_listeners(evt)", function()
    local e = EventEmitter()

    local called = 0

    e.add_listener("foo", function()
      called = called + 1
    end)
    e.add_listener("foo", function()
      called = called + 1
    end)
    e.add_listener("bar", function()
      called = called + 1
    end)

    e.remove_all_listeners("foo")

    e.emit("foo")
    e.emit("bar")

    assert.same(1, called)
  end)
  it("calls once only once", function()
    local e = EventEmitter()

    local called = 0

    e.once("foo", function()
      called = called + 1
    end)

    e.emit("foo")
    e.emit("foo")
    e.emit("foo")

    assert.same(1, called)
  end)
  it("on is synonymous with add_listener", function()
    local e = EventEmitter()

    local called = 0

    local my_listener = function()
      error("Should not be called")
    end

    e.on("foo", my_listener)
    e.on("foo", function()
      called = called + 1
    end)

    e.remove_listener("foo", my_listener)

    e.emit("foo")

    assert.same(1, called)
  end)
  it("off is synonymous with remove_listener", function()
    local e = EventEmitter()

    local called = 0

    local my_listener = function()
      error("Should not be called")
    end

    e.on("foo", my_listener)
    e.on("foo", function()
      called = called + 1
    end)

    e.remove_listener("foo", my_listener)

    e.emit("foo")

    assert.same(1, called)
  end)
end)
