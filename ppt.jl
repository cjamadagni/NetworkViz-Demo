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
    num = Input(10)
    toggle = Input(false)
    slidebody(body) = body |> fontsize(1.2em) |> lineheight(2em)

    g = Graph(10)

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
        drawGraph(CompleteGraph(6),1),
        drawGraph(CompleteGraph(6),0),
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
            drawGraph(WheelGraph(frames.value+1),1)
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
        title(3,"What have we worked on?"),
        vskip(2.5em),
        "We have created a graph visualization library in Julia language which allows for both 2D and 3D visualizations of graphs which can be input by the users. We have also incorporated zoom capability to allow the library to be used for a multitude of applications including education, traffic signal network visualisation, complex internet network visualizations etc. in which everything revolves around graphs and our ability to perceive and comprehend them."
    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"What is Julia?"),
        vskip(2.5em),
        md"""
        Julia is a high-level, high-performance dynamic programming language for technical computing, with syntax that is familiar to users of other technical computing environments. It is also a NumFocus project started by students at MIT which was commercialised in 2012 and is now a full fledged startup, Julia Computing.
        """
    ) |>slidebody |> pad(6em),


    vbox(
        title(3,"Why Julia?"),
        vskip(2.5em),
        md"""
        Julia’s LLVM-based just-in-time (JIT) compiler combined with the language’s design allow it to approach and often match the performance of C. This allows for the ease of use of languages similar to python at the performance of C.
        """,
        vskip(2em),
        # image("https://drive.google.com/file/d/0B414CCVd1zpIT2doRjZxLXppekY4SmEydkx1YllJbk16UVRR/view?usp=sharing")

        image("/pkg/Escher/whyjulia.jpg")

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"What have we achieved?"),
        vskip(2.5em),
        md"""
        We have managed to create a stable, robust graph visualization library which allows the user to bring any graph or operational result to life through a 3D/2D visualization of the same.
        Salient features of our project:

        - Allows for easy toggling between 2D and 3D representations of the graph, i.e.  any graph which is input would result in a visualization being rendered which can be switched from 2D to 3D by changing the z-axis parameter allowing for a more vibrant experience.

        - Only requires adjacency matrix for graph visualization; any and all graphs to be input by the user can be done using an adjacency matrix which would now provide the opportunity to visualize the effect of various graph operations on the graph structure.

        - Tight coupling with existing(non-visualization) graph libraries in Julia which allows for easier expansions in the future along with stronger credibility within the Julia community.

        - Zoom capability for careful examination of the graph and its intricate structural changes due to various operations and for viewing the larger layout of the graph allowing for a wider network topology view of the graph.
        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"WebGL"),
        vskip(2.5em),
        md"""
        WebGL (Web Graphics Library) is a JavaScript API for rendering interactive 3D computer graphics and 2D graphics within any compatible web browser without the use of plug-ins.

        - Since it works in a web browser, it's platform independent.

        - We are using a Julia abstraction over WebGL to render 3D and 2D objects.

        - Our Julia code triggers the execution of javascript code in the browser. The browser then executes the code on the computer's GPU.
        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Escher.jl"),
        vskip(2.5em),
        md"""
        We are using `Escher.jl` to serve web UIs written entirely in Julia.

        - Escher's built-in web server allows you to create interactive UIs with very little code. It takes care of messaging between Julia and the browser under-the-hood. It can also hot-load code: you can see your UI evolve as you save your changes to it.

        - The built-in library functions support Markdown, Input widgets, TeX-style Layouts, Styling, TeX, Code, Behaviors, Tabs, Menus, Slideshows, Plots (via Gadfly) and Vector Graphics (via Compose) – everything a Julia programmer would need to effectively visualize data or to create user-facing GUIs. The API comprehensively covers features from HTML and CSS, and also provides advanced features. Its user merely needs to know how to write code in Julia.
        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Reactive Programming"),
        vskip(2.5em),
        md"""
         Reactive programming is a programming paradigm oriented around data flows and the propagation of change. This means that it should be possible to express static or dynamic data flows with ease in the programming languages used, and that the underlying execution model will automatically propagate changes through the data flow.

        - It makes writing event-driven programs simple.

        - `Reactive.jl` contains the pure julia implementation of reactive programming primitives.
        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Camera Primitives"),
        vskip(2.5em),
        md"""
        No 3D scene can be properly displayed without a camera to view from. We provide support for a Perspective Camera view using the camera function.
    		This sets the position of the camera, along with properties like near plane, far plane, fov for field of view (in degrees), and aspect ratio.

        `PerspectiveCamera(fov, aspect, near, far)`

    		- `fov` — Camera frustum vertical field of view.
    		- `aspect` — Camera frustum aspect ratio.
    		- `near` — Camera frustum near plane.
    		- `far` — Camera frustum far plane.
        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Basic Primitives"),
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
        title(3,"Basic Primitives - Drawing the Graph"),
        vskip(2.5em),
        md"""
         `drawGraph` is extremely flexible. It can accept a graph, directed graph or an adjacency matrix.

         - `drawGraph(g::Union{LightGraphs.DiGraph,LightGraphs.Graph},z::Int)`

         - `drawGraph{T}(adjacencyMatrix::Array{T,2},z::Int)`

        """,
        vskip(1.5em),
        md"""
        *z = [0,1] makes the resulting graph 2D or 3D respectively.*
        """

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Spring Embedder Algorithm"),
        vskip(2.5em),
        md"""
        We have managed to create a stable, robust graph visualization library which allows the user to bring any graph or A spring embedder considers the nodes little metal rings in the plane that are connected by springs and that therefore repel or attract each other.

     		A spring embedder works in iterations. In each iteration, the forces exerted on each node v are computed. Each incident edge (u,v) attracts the node v with the force f(u,v) in the direction of u, with f(u,v) being proportional to the difference from the distance of u and v and the length of the spring (“Hooke's Law”). Conversely, each leaving edge (v,u) repels the node v away from from u with the force f(v,u)=−f(u,v).

     		After all forces have been summed up, the rings are moved in the plane according to the forces exerted on them. (By the force exerted on it, a ring is subject to a certain acceleration into a certain direction that is considered constant for a short period; the new position of the ring is the position at the end of this period.) Then the spring embedder steps into the next iteration.

     		With a sufficiently large number of iterations, a state of equilibration is reached, in which the force exerted on each ring is 0.
        """

    ) |>slidebody |> pad(6em),

    completeGraphExample,

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
        title(3,"Remove Edge Demo"),
        vskip(2.5em),
        md"""
        The following examples shows a complete graph with 10 vertices. Edges can be removed one after the other by entering the source and destination vertices. Attempting to remove an edge which doesn't exist will trigger a silent failure.
        """,
        Elem(:a, "Link", attributes = Dict(:href => "http://localhost:3000/removeedge.jl"))

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
        title(3,"Example of a path"),
        vskip(2.5em),
        md"""
        This example shows an animation for a walk/path having 10 nodes.
        """,

        Elem(:a, "Link", attributes = Dict(:href => "http://localhost:3000/edgeanim.jl"))

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"Where do we go from here?"),
        vskip(2.5em),
        md"""
        We hope to expand our library to support extensive animations that would further our goal of creating a library which allows users to perceive and understand some of the most complex network structures be it in city management or educational circles.
        We also imagine it to have specific applications in the area of network topology visualization which would allow for it to be used as an instrumental part of network configuration simulators.

        Another interesting real-world application we can hope to target is a simple way to visualize complex city road structures and signals which currently require specialists trained in traffic network simulators like SUMO, using our library it would be a far simpler task to work off of a gui which allows you to views the entire traffic network at a glance and also zero in on specific locations in the city layout.
        """
    ) |>slidebody |> pad(6em),

        vbox(
        title(3,"What is our next step?"),
        vskip(2.5em),
        md"""
        The third Julia conference will take place June 21st-25th, 2016 at the Massachusetts Institute of Technology in Cambridge, Massachusetts. We hope to present a talk at this prestigious conference on our work with NetworkViz.jl library and have started preparations to achieve the same.

        We also hope to submit a research paper on our work to the SummerSim’16 conference to be held from July 24-27, 2016 at Palais des congres de Montreal, Quebec, Canada which is a conference focussed on modeling and simulation tools, theory, methodologies and applications and is thus a forum for the latest R&D results in academia and industry.
        """
    ) |>slidebody |> pad(6em),








    ])
end
