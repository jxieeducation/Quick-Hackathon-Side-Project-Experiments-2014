package udfs;

import org.apache.pig.EvalFunc;
import org.apache.pig.data.DataBag;
import org.apache.pig.data.Tuple;

import java.io.IOException;
import java.util.Iterator;


public class USDtoYUAN extends EvalFunc<float> {
    @Override 
    public float exec(Tuple input) throws IOException {
        if (input == null)
        {
            return null;
        }
        String symbol = (String)input.get(0);
        float money = (float)input.get(1);
        money *= 9.7;
        return money;
    }
}