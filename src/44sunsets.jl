using Colors
using Javis

function ground(args...)
    background("black")
    sethue("white")
    return nothing
end

function title_object(ptitle)
    fontsize(20)
    text("Little Prince 44 sunsets in a day", ptitle, valign = :middle, halign = :center)
    return nothing
end

function intro_text_object(pt_text, width_text)
    fontsize(20)
    #=     textwrap("Here comes some introductory story about Little Prince"
            * "and his little planet, and blah, blah, blah", width_text,
            pt_text) =#
    textbox(
        [
            "Here is the story",
            "of this little fella",
            "known as the Little Prince",
            "and the day he saw",
            "44 sunsets,",
            "on a single day,",
            "walking around",
            "his little planet.",
        ],
        pt_text,
    )
    return nothing
end

function sun_object(c, r, d, θ)
    sun_color = RGB(1.0, 0.9, 0.2)
    sethue(sun_color)
    circle(c + d * Point(cos(θ), sin(θ)), r, :fill)
    return nothing
end

function planet_object(c, r, θ)
    planet_shadow_color = RGB(0.01, 0.04, 0.12)
    planet_sunny_color = RGB(0.4, 0.8, 1.0)
    sethue(planet_shadow_color)
    # circle(c, r, :fill)
    for ζ = 0:0.02:1
        α = π * ζ / 2
        p = 2.5
        sethue((1 - ζ^p) * planet_sunny_color + ζ^p * planet_shadow_color)
        P1 = c + r * Point(cos(θ + α), sin(θ + α))
        P2 = c + r * Point(cos(θ - α), sin(θ - α))
        arc2r(c, P1, P2, :fill)
    end
    stem_color = 0 < θ < π ? sethue("darkgreen") : sethue("lightgreen")
    flower_color = 0 < θ < π ? sethue("darkred") : sethue("red")
    sethue(stem_color)
    rect(c - r * Point(0, 1.0) - Point(r / 40.0, r / 10.0), r / 20.0, r / 5.0, :fill)
    sethue(flower_color)
    circle(c - r * Point(0.0, 1.0) - Point(0.0, r / 6.0), r / 12, :fill)
    return nothing
end

function make_scene()
    nframes = 400

    width, height = 854, 480 # approximatey 16:9 aspect ratio
    origin = Point(div(height, 2) - div(width, 2), 0)
    ptitle = origin - Point(0, 0.9 * div(height, 2))

    pt_intro_text = origin + Point(div(height, 2), -div(height, 5))
    width_intro_text = div(height, 2)

    vid = Video(width, height)

    fadein = 20
    fadeout = 10

    title_n0, title_n1, title_nf = 1, 100, 100
    intro_n0, intro_n1, intro_nf = 81, 300, 220

    Background(1:nframes, ground)

    title = Object(title_n0:title_n1, (args...) -> title_object(ptitle))
    act!(
        title,
        [
            Action(title_n0:title_n0+fadein, appear(:fade)),
            Action(title_nf-fadeout:title_nf, disappear(:fade)),
        ],
    )

    intro_text = Object(
        intro_n0:intro_n1,
        (args...) -> intro_text_object(pt_intro_text, width_intro_text),
    )
    act!(
        intro_text,
        [
            Action(1:fadein, appear(:fade)),
            Action(intro_nf-fadeout:intro_nf, disappear(:fade)),
        ],
    )

    sun = Object(1:nframes, (args...; θ) -> sun_object(origin, 20, 220, θ))
    act!(sun, Action(1:nframes, change(:θ, 0 => 2π)))

    planet = Object(1:nframes, (args...; θ) -> planet_object(origin, 80, θ))
    act!(planet, Action(1:nframes, change(:θ, 0 => 2π)))

    render(vid; pathname = joinpath("..", "images", "44sunsets.gif"))
end

make_scene()
