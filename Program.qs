namespace test {

    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
    @EntryPoint()
    operation SayHello() : String {
        let qubitOneCount = GetMeasuresOfSingleQubit100Times();
        Message($"qubit equal to One count of 1000 measures is {qubitOneCount}");
        return "Hello quantum world!";
    }


    operation GetMeasuresOfSingleQubit100Times(): Int {
        let amount = 1000;
        mutable positives = 0;

        for i in 0..amount {
            use q = Qubit();
            H(q);
            if M(q) == One {
                set positives = positives+1;
            }
            let res = M(q);
            Reset(q);
        }
        return positives;
    }
}
