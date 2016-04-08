/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package sources;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import processflow.Var;

/**
 *
 * @author gendrok
 */
public class FieldVar implements Comparable<FieldVar> {
    
    private final Field field;
    private final Var var;
    private final String type;
    
    FieldVar(Field field, Var var) {
        this.field = field;
        this.var = var;
        this.type = composeType(field);
    }
    
    public Field getField() {
        return field;
    }
    
    public Var getVar() {
        return var;
    }
    
    public String getType() {
        return type;
    }
    
    @Override
    public int compareTo(FieldVar v) {
        return var.compareTo(v.var);
    }
    
    public double isInstance(Object obj) {
        Type t = field.getGenericType();
        if (t instanceof ParameterizedType) {
            //Most Var fields will be declared as Var<Some type>
            ParameterizedType pt = (ParameterizedType)t;
            t = pt.getActualTypeArguments()[0];
            return isInstance(t, obj, 0.0);
        }
        return 0.0;
    }
    
    private static double isInstance(Type t, Object v, double depth) {
        if (v!=null) {
            if (t instanceof Class) {
                if (((Class)t).isInstance(v)) {
                    if (t.equals(Object.class)) {
                        depth += 0.5; //Object type is rated lower
                    } else {
                        depth += 1.0;
                    }
                }
            } else if (t instanceof ParameterizedType) {
                depth = isInstance((ParameterizedType)t, v, depth);
            } else {
                depth += 1.0;
            }
        } else {
            depth += 1.0;
        }
        return depth;
    }
    
    private static double isInstance(ParameterizedType pt, Object obj, double depth) {
        Type t = pt.getRawType();
        //Object must be an instance of the raw type
        if (t instanceof Class && ((Class)t).isInstance(obj)) {
            depth += 1.0;
            Class c = (Class)t;
            Type[] param = pt.getActualTypeArguments();
            //Handle the two primary types, maps and collections
            if (Map.class.isAssignableFrom(c)) {
                Iterator i = ((Map)obj).entrySet().iterator();
                if (i.hasNext()) {
                    Map.Entry e = (Map.Entry)i.next();
                    double kDepth = isInstance(param[0], e.getKey(), depth) - depth;
                    double vDepth = isInstance(param[1], e.getValue(), depth) - depth;
                    depth += (kDepth+vDepth)/2;
                }
            } else if (Collection.class.isAssignableFrom(c)) {
                Iterator i = ((Collection)obj).iterator();
                if (i.hasNext()) {
                    depth = isInstance(param[0], i.next(), depth);
                }
            }
        }
        return depth;
    }
    
    private static String composeType(Field field) {
        Type t = field.getGenericType();
        if (t instanceof ParameterizedType) {
            //Most Var fields will be declared as Var<Some type>
            ParameterizedType pt = (ParameterizedType)t;
            t = pt.getActualTypeArguments()[0];
            return composeType(t);
        }
        return Object.class.getSimpleName();
    }
    
    private static String composeType(Type t) {
        if (t instanceof Class) {
            return ((Class)t).getSimpleName();
        } else if (t instanceof ParameterizedType) {
            return composeType((ParameterizedType)t);
        } else {
            return Object.class.getSimpleName();
        }
    }
    
    private static String composeType(ParameterizedType pt) {
        Type t = pt.getRawType();
        if (t instanceof Class) {
            Class c = (Class)t;
            Type[] param = pt.getActualTypeArguments();
            StringBuilder sb = new StringBuilder();
            sb.append(c.getSimpleName());
            if (param.length!=0) {
                sb.append("<");
                for (int ii=0;ii<param.length;ii++) {
                    if (ii!=0) {
                        sb.append(", ");
                    }
                    sb.append(composeType(param[ii]));
                }
                sb.append(">");
            }
            return sb.toString();
        } else {
            return Object.class.getSimpleName();
        }
    }
    
}
