local function property_baseline(jump_index)
  return sn(
    jump_index,
    fmt(
      [[
        @property
        def {property_name}(self) -> {property_type}:
            {property_body}
      ]],
      {
        property_name = i(1, "property_name", { key = "propname" }),
        property_type = i(2, "property_type", { key = "proptype" }),
        property_body = i(3, "pass"),
      }
    )
  )
end

local function setter_property(jump_index, property_base_node)
  return sn(
    jump_index,
    fmt(
      [[
      @{name}.setter
      def {name}(self, {new_value}: {type}) -> None:
          {body}
      ]],
      {
        name = rep(k("propname")),
        new_value = i(1, "new_value"),
        type = rep(k("proptype")),
        body = i(2, "pass"),
      }
    )
  )
end

return {
  s(
    {
      trig = "classmethod",
      name = "Class method",
      dscr = "Class method spet",
    },
    fmt(
      [[
          @classmethod
          def {}(cls, {}) -> {}:
              {}
          ]],
      {
        i(1, "fun"),
        i(2, "args"),
        i(3, "Self"),
        i(4, "pass"),
      }
    )
  ),
  s(
    {
      trig = "ifnamemain",
      name = "If name equals main",
      dscr = "If name main copy pasta",
    },
    fmt(
      [[
          def {function_name}():
              {fun_body}


          if __name__ == "__main__":
              {reflected_fun_name}()
          ]],
      {
        function_name = i(1, "main"),
        fun_body = i(2, "pass"),
        reflected_fun_name = rep(1),
      }
    )
  ),
  s(
    {
      trig = "notimplementedyet",
      name = "Raise Not implemented yet assertion",
      dscr = "Frequently used placeholder for immediate warning in case of using not yet implemented functionality",
    },
    fmt(
      [[
          raise NotImplementedError
          ]],
      {}
    )
  ),
  s(
    {
      trig = "property",
      name = "Pure property",
      descr = "Property without getter/setter",
    },
    fmt(
      [[
    {property_base}
  ]],
      {
        property_base = property_baseline(1),
      }
    )
  ),
  s(
    {
      trig = "propertysetter",
      name = "Property with setter",
      descr = "Property with setter",
    },
    fmt(
      [[
  {property_base}

  {property_setter}
  ]],
      {
        property_base = property_baseline(1),
        property_setter = setter_property(2, ai[1]),
      }
    )
  ),
  s(
    {
      trig = "matplotlib",
      name = "matplotlib as plt",
      descr = "Common matplotlib.pyplot as plt import"
    },
    fmt(
      [[
        import matplotlib.pyplot as plt
      ]],
      {}
    )
  ),
  )
  s(
    {
      trig = "numpy",
      name = "numpy as np",
      descr = "Common numpy as np imoprt"
    },
    fmt(
      [[
        import numpy as np
      ]],
      {}
  ),
}
