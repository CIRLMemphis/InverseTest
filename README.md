# InverseTest: a Testing Framework for inverse problem, applied to 3D Structured Illumination Microscopy (3D-SIM)
Images collected by 3D-SIM can be modeled as

`g = Hf`

where `H` is the forward model, `g` is the data of size `[X, Y, Z]` and `f` is the object of size `[2X, 2Y, 2Z]`.

**Inverse prolem:** given the data `g`, restore the object `f`.

**Optimization-based solution:** one can solve the above inverse problem by solving the optimization problem:

f<sub>r</sub> = H<sup>-1</sup>g := argmin<sub>f</sub> (||Hf - Ug|| + R(f))

where f<sub>r</sub> is the restoration, `U` is the upsampling operator/function, `R` is the regularization, and H<sup>-1</sup> is the inverse operator/function.

**Testing framework:** to test the optimization-based solution, one creates some simulated object f<sub>s</sub>, applies `H` to f<sub>s</sub> to obtain the simulated data g<sub>s</sub>, then uses optimization-based solution to obtain the restoration f<sub>r</sub>. One then checks whether f<sub>r</sub> is the same as f<sub>s</sub>. In otherwords, the input and output of this testing framework should be:

**Input:**

- Settings object: containg all the parameters of the inverse problem, i.e. in SIM, the parameters are wavelength, NA, etc.

- Dimensions `[X, Y, Z]`

- Forward function `H`

- Restoration function H<sup>-1</sup>

- Simulation function `S` to generate simulated data f<sub>s</sub>

**Output:**

- Relative error between the restoration f<sub>r</sub> and the simulated object f<sub>s</sub>: ||f<sub>r</sub> - f<sub>s</sub>||/||f<sub>s</sub>||.
