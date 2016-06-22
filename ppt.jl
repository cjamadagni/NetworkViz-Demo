#NetworkViz.jl demo

using LightGraphs
using NetworkViz
using ThreeJS
using Colors
using Escher


function main(window)
    push!(window.assets, "animation")
    push!(window.assets, "widgets")
    push!(window.assets, "tex")
    push!(window.assets, "layout2")
    push!(window.assets, ("ThreeJS","threejs"))
    push!(window.assets, "codemirror")
    num = Signal(10)
    toggle = Signal(false)
    slidebody(body) = body |> fontsize(1.2em) |> lineheight(2em)

    g = Graph(10)

    usage_code = """g = CompleteGraph(10)
    c = Color[parse(Colorant,"#00004d") for i in 1:nv(g)]
    n = NodeProperty(c,0.2,0) #NodeProperty(color,size,shape)
    e = EdgeProperty("#ff3333",1) #EdgeProperty(color,width)
    drawGraph(g,node=n,edge=e,z=1) #Draw using a Graph object (3D).
    am = full(adjacency_matrix(g))
    drawGraph(am,node=n,edge=e,z=0) #Draw using an adjacency matrix (2D).
    dgraph = bfs_tree(g,1)
    drawGraph(dgraph,z=1) #Draw a Digraph."""

    # For animate.jl
    fps1 = fps(1)
    frames = foldp(+, 1, map((x)->1, fps1))
    running = map(x->x<49, frames)

    # For edgeanim.jl
    running2 = map(x->x<9, frames)


    tabbar = tabs([
                hbox(icon("face"), hskip(1em), "3D"),
                hbox(icon("explore"), hskip(1em), "2D"),
            ])

    tabcontent = pages([
        drawGraph(CompleteGraph(6),z=1),
        drawGraph(CompleteGraph(6),z=0),
    ])

    t, p = wire(tabbar, tabcontent, :tab_channel, :selected)



    # Text Support Example
    textSupport = vbox(
            drawGraphwithText(CompleteGraph(10),1)
            ) |> size(80em, 50em) |> pad(6em)


    # Edge Animation Example
    edgeAnimate = vbox(
            map(fpswhen(running2, 1)) do _
                addEdge(g,frames.value,frames.value+1,1)
            end
        ) |> pad(2em)



    # Animate.jl Example
    animate = vbox(
        map(fpswhen(running, 1)) do _
            drawGraph(WheelGraph(frames.value+1),z=1)
        end
    )

    # Complete Graph Example
    completeGraphExample= vbox(
        title(2,"Complete Graph Example"),
        vskip(2em),
        "Visualization of a complete graph with 6 nodes.",
        vskip(2em),

        vbox(t,p)

        #drawGraph(CompleteGraph(6),1)

        ) |> size(80em, 50em)


    # Wheel Graph Example
    wheelGraphExample= vbox(
        title(2,"Wheel Graph Example"),
        vskip(2em),
        vbox(
            "Number of Nodes",
            slider(10:100) >>> num,

            "2D/3D",
            vskip(1em),
            togglebutton() >>> toggle
        ),
        vskip(1em),
        lift(toggle,num) do t,n
            drawWheel(n,t)
        end
        ) |> size(80em, 50em)


    # Display begins here
    slideshow([

    vbox(title(4,"NetworkViz.jl")),

    vbox(
        title(3,"What does NetworkViz do?"),
        vskip(2.5em),
        "NetworkViz is a graph visualization package in Julia which allows for both 2D and 3D visualizations of graphs which can be input by the users. The package can be used for a multitude of applications including education, traffic signal network visualisation, complex internet network visualizations etc. in which everything revolves around graphs and our ability to perceive and comprehend them."
    ) |>slidebody |> pad(6em),


    vbox(
        title(3,"Why NetworkViz?"),
        vskip(2.5em),
        md"""
        * Existing Graph visualization packages support only 2D visualization.

        * Using NetworkViz with Escher helps in creating interactive applications.

        * Use of ThreeJS (uses WebGL) makes the package easy to use without any additional plugins.
        """,
        vskip(2em),

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Using NetworkViz - Pros"),
        vskip(2.5em),
        md"""
        NetworkViz is a stable graph visualization package which allows the user to bring any graph or operational result to life through a 3D/2D visualization of the same.
        Salient features:

        - Allows for easy toggling between 2D and 3D representations of the graph, i.e.  any graph which is input would result in a visualization being rendered which can be switched from 2D to 3D by changing the z-axis parameter allowing for a more vibrant experience.

        - Only requires adjacency matrix for graph visualization; any and all graphs to be input by the user can be done using an adjacency matrix which would now provide the opportunity to visualize the effect of various graph operations on the graph structure.

        - Tight coupling with LightGraphs.jl, i.e. a LightGraphs object can be visualized directly by passing it to NetworkViz.
        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"How does it work?"),
        vskip(2.5em),
        md"""
        * NetworkViz uses ThreeJS.jl for visualizing graphs using WebGL.

        * Uses Spring Embedder Algorithm for calculating co-ordinates.

        * A graph is constructed using *pointcloud()* [that visualizes all the nodes of the graph] and *line()* [used to visualize the edges of the graph]
        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Spring Embedder Algorithm"),
        vskip(2.5em),
        md"""
          A spring embedder considers the nodes little metal rings in the plane that are connected by springs and that therefore repel or attract each other.

          A spring embedder works in iterations. In each iteration, the forces exerted on each node v are computed. Each incident edge (u,v) attracts the node v with the force f(u,v) in the direction of u, with f(u,v) being proportional to the difference from the distance of u and v and the length of the spring (“Hooke's Law”). Conversely, each leaving edge (v,u) repels the node v away from from u with the force f(v,u)=−f(u,v).

          After all forces have been summed up, the rings are moved in the plane according to the forces exerted on them. (By the force exerted on it, a ring is subject to a certain acceleration into a certain direction that is considered constant for a short period; the new position of the ring is the position at the end of this period.) Then the spring embedder steps into the next iteration.

          With a sufficiently large number of iterations, a state of equilibration is reached, in which the force exerted on each ring is 0.

        """

    ) |>slidebody |> pad(6em),

    completeGraphExample,

    vbox(
        title(3,"Basic Primitives - Drawing a Graph"),
        vskip(2.5em),
        md"""
         - `drawGraph(g::Union{LightGraphs.DiGraph,LightGraphs.Graph}; node::NodeProperty, edge::EdgeProperty, z=Int)`

         - `drawGraph(am::Array{Int,2}; node::NodeProperty, edge::EdgeProperty, z=Int)`
        """,
        vskip(1.5em),
        md"""
        *z = [0,1] makes the resulting graph 2D or 3D respectively.*
        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Basic Primitives - Utility Functions"),
        vskip(2.5em),
        md"""
         - `addNode(g::Graph, z::Int)`

         - `removeNode(g::Graph, z::Int)`

         - `addEdge(g::Graph, source::Int, destination::Int, z::Int)`

         - `removeEdge(g::Graph, source::Int, destination::Int, z::Int)`
        """,
        vskip(1.5em),
        md"""
        *z = [0,1] makes the resulting graph 2D or 3D respectively.*
        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Usage - Drawing a Graph"),
        vskip(2.5em),
        md"""
        The drawGraph function can be used to draw the graphs in 2D or 3D with nodes having different colors. It can accept *LightGraphs.Graph* and *LightGraphs.Digraph* types. *drawGraph* can be used to draw graphs from adjacency matrices also. The function accepts additional kwargs *node::NodeProperty*, *edge::EdgeProperty*, and *z*. If *z=1*, it draws a 3D graph. If *z=0*, a 2D visualization of the graph is drawn. *node* and *edge* determines the properties of nodes and edges respectively.

        """,
        codemirror(usage_code),
        vskip(1.5em),

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Demos"),
        vskip(2.5em),
    ) |>slidebody |> pad(6em),

    wheelGraphExample |> pad(2em),

    vbox(
        title(3,"Add Edge Demo"),
        vskip(2.5em),
        md"""
        The following program demonstrates edges being added to an empty graph of 10 nodes. Trying to add an edge which already exists results in the edge being re drawn.
        """,
        Elem(:a, "Link", attributes = Dict(:href => "http://localhost:3000/addedge.jl"))

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Breadth First Search Example"),
        vskip(2.5em),
        md"""
        The following example shows a complete graph. The number of vertices can lie in the range 10-100. Breadth First Search Operation is performed with node 1 as the starting vertex. The result will be an acyclic graph.
        """,
        Elem(:a, "Link", attributes = Dict(:href => "http://localhost:3000/bfs.jl"))

    ) |>slidebody |> pad(6em),


    vbox(
        title(3,"Code Mirror Example"),
        vskip(2.5em),
        md"""
        This is an example for a live code or hot code. Valid Julia graph operations can be typed in the editor and the appropriate change will be immediately reflected. Any error will fail silently.
        """,
        Elem(:a, "Link", attributes = Dict(:href => "http://localhost:3000/typefunction.jl"))

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Text Support Example"),
        vskip(2.5em),
        md"""
        This is an example for basic text support. Each vertex is associated with a `node ID`.
        """,
        Elem(:a, "Link", attributes = Dict(:href => "http://localhost:3000/text.jl"))


    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Animation Example"),
        vskip(2.5em),
        md"""
        This is an example for graph animation. On clicking the link, you will see a growing wheel graph. The graph will grow until it has 50 nodes.
        """,

        Elem(:a, "Link", attributes = Dict(:href => "http://localhost:3000/animate.jl"))


    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Further Development"),
        vskip(2.5em),
        md"""
        NetworkViz is a new package that is still in its infancy. There are many aspects in which it requires improvement.

        * The Spring Embedder Algorithm takes nearly 2 mins for computing co-ordinates of a graph with 10,000 edges (Slow!)
        * Better text support
        * Coloring and sizing of individual edges and nodes
        * Blink Integration

        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Thank you"),
        vskip(2.5em),
    ) |>slidebody |> pad(6em),

    ])
end
