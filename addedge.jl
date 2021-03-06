# Example which demonstrates adding an edge

using LightGraphs
using NetworkViz
using ThreeJS
using Escher

g = Graph(10)

main(window) = begin
  push!(window.assets, "widgets")
  push!(window.assets,("ThreeJS","threejs"))

  inp = Signal(Dict{Any, Any}(:node1=>"3",:node2=>"3"))

  s = Escher.sampler()
  sampler = Escher.sampler()
  form = vbox(
      h1("Add New Edge"),
      watch!(s, :node1, textinput("", label="Source Vertex")),
      watch!(s, :node2, textinput("", label="Destination Vertex")),
      trigger!(s, :submit, button("Add Edge"))
  ) |> maxwidth(400px)

  map(inp) do dict
      node1 = parse(Int,dict[:node1])
      node2 = parse(Int,dict[:node2])
      vbox(
          intent(s, form) >>> inp,
          vskip(2em),
          addEdge(g, node1, node2, 0)
      ) |> Escher.pad(2em)
  end
end
