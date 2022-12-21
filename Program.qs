namespace brainy {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;
    
    // @EntryPoint()
    operation SayHello() : Unit {
        Message("Hello quantum world!");
    }

// @EntryPoint()
    operation SingleQubit() : Result {
        //create a single qubit quantum register
        // it is initialized in |0> state
        use qubitRegister = Qubit();
        return M(qubitRegister);
        //it is now equivalent to a classical bit in 0 state
    }

// @EntryPoint()
    operation MultipleMeasurementsOfZero(): Double {
        let amount = 100;
        mutable counter = 0;
        for n in 1 .. amount {
            let q = SingleQubit();
            if q == Zero {
                set counter = counter + 1;
            }
        }
        Message("Probability of measurement result being Zero is :");
        return IntAsDouble(counter)/IntAsDouble(amount);

    }

    // @EntryPoint()
    operation MultipleMeasurementsOfOne(): Double {
        let amount = 100;
        mutable counter = 0;
        for n in 1 .. amount {
            let q = SingleQubit();
            if q == One {
                set counter = counter + 1;
            }
        }
        Message("Probability of measurement result being One is :");
        return IntAsDouble(counter)/IntAsDouble(amount);
    }

    operation SingleQubitWithSuperposition() : Result {
        
        use qubitRegister = Qubit();
        //apply Hadamard gate, which transitions the state to
        //a linear combination of |0> and |1> with 50% probability
        H(qubitRegister);
        return M(qubitRegister);

    }

    // @EntryPoint()
    operation MultipleMeasurementsOfOneWithSuperpositionApplied(): Double {
        let amount = 100;
        mutable counter = 0;
        for n in 1 .. amount {
            let q = SingleQubitWithSuperposition();
            if q == One {
                set counter = counter + 1;
            }
        }
        Message("Probability of measurement result being One is :");
        return IntAsDouble(counter)/IntAsDouble(amount);
    }

    // there are more gates, such as Z, X or Y and infinitely many more
    // a gate is just a matrix that is applied to a vector representing a quantum state
    // a quantum state is a linear combination of basis states
    // H(|0>) = a|0> + b|1>
    // a = b = 1/sqrt(2)
    // P(H(|0>)) = |0> = 1/2
    // a and b can be complex numbers, 
    // they can have an intrinsic phase that cannot be directly measured
    // but this phase can be interfered and thus is important for calculations

    //now, more qubits can be added
    // let's measure the probabilities of 4 possible states
    // in a 2-qubit system with Hadamard applied

    // @EntryPoint()
    operation TwoQubitMultipleMeasurementsOfOneWithSuperpositionApplied(): Unit {
        let amount = 500;
        mutable counters = [0.,0.,0.,0.];

        for n in 1 .. amount {
            use q1 = Qubit();
            use q2 = Qubit();
            H(q1);
            H(q2);
            let q1Value = M(q1);
            let q2Value = M(q2);

            if q1Value == Zero and q2Value == Zero {
                set counters w/= 0 <- counters[0] + IntAsDouble(1)/IntAsDouble(amount);
            }
            if q1Value == One and q2Value == Zero {
                set counters w/= 1 <- counters[1] +  IntAsDouble(1)/IntAsDouble(amount);
            }
            if q1Value == Zero and q2Value == One {
                set counters w/= 2 <- counters[2] +  IntAsDouble(1)/IntAsDouble(amount);
            }
            if q1Value == One and q2Value == One {
                set counters w/= 3 <- counters[3] +  IntAsDouble(1)/IntAsDouble(amount);
            }
        }
        Message("Probabilities of measurement result:");
        Message($"|00>: {counters[0]}");
        Message($"|10>: {counters[1]}");
        Message($"|01>: {counters[2]}");
        Message($"|11>: {counters[3]}");
        // all binary values of 0, 1, 2 and 3 can be stored simultaneously
        // in a set of two qubits in superposition state
    }

    // now with only one H operation and no entanglement
    // @EntryPoint()
    operation TwoQubitMultipleMeasurementsWithOneSuperpositionApplied(): Unit {
        let amount = 500;
        mutable counters = [0.,0.,0.,0.];

        for n in 1 .. amount {
            use q1 = Qubit();
            use q2 = Qubit();
            H(q1);
            // H(q2);
            let q1Value = M(q1);
            let q2Value = M(q2);

            if q1Value == Zero and q2Value == Zero {
                set counters w/= 0 <- counters[0] + IntAsDouble(1)/IntAsDouble(amount);
            }
            if q1Value == One and q2Value == Zero {
                set counters w/= 1 <- counters[1] +  IntAsDouble(1)/IntAsDouble(amount);
            }
            if q1Value == Zero and q2Value == One {
                set counters w/= 2 <- counters[2] +  IntAsDouble(1)/IntAsDouble(amount);
            }
            if q1Value == One and q2Value == One {
                set counters w/= 3 <- counters[3] +  IntAsDouble(1)/IntAsDouble(amount);
            }
        }
        Message("Probabilities of measurement result with only one Hadamard gate applied:");
        Message($"|00>: {counters[0]}");
        Message($"|10>: {counters[1]}");
        Message($"|01>: {counters[2]}");
        Message($"|11>: {counters[3]}");
    }

    // now with entanglement on
    @EntryPoint()
    operation TwoQubitMultipleMeasurementsWithOneSuperpositionAppliedAndEntanglement(): Unit {
        let amount = 500;
        mutable counters = [0.,0.,0.,0.];

        for n in 1 .. amount {
            use q1 = Qubit();
            use q2 = Qubit();
            H(q1);
            // H(q2);
            CNOT(q1,q2);
            // CNOT matrix sets the q2 to opposite to q1
            // if q1 is Zero, then sets q2 as One etc

            let q1Value = M(q1);
            let q2Value = M(q2);

            if q1Value == Zero and q2Value == Zero {
                set counters w/= 0 <- counters[0] + IntAsDouble(1)/IntAsDouble(amount);
            }
            if q1Value == One and q2Value == Zero {
                set counters w/= 1 <- counters[1] +  IntAsDouble(1)/IntAsDouble(amount);
            }
            if q1Value == Zero and q2Value == One {
                set counters w/= 2 <- counters[2] +  IntAsDouble(1)/IntAsDouble(amount);
            }
            if q1Value == One and q2Value == One {
                set counters w/= 3 <- counters[3] +  IntAsDouble(1)/IntAsDouble(amount);
            }
        }
        Message("Probabilities of measurement result with entanglement:");
        Message($"|00>: {counters[0]}");
        Message($"|10>: {counters[1]}");
        Message($"|01>: {counters[2]}");
        Message($"|11>: {counters[3]}");
    }

}
