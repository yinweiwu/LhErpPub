var JSONArraySort = {
    init: function (arry, parm, sortby) {
        this.obj = arry
        this.parm = parm
        this.b = sortby
    },
    sort: function () {
        var $this = this
        var down = function (x, y) {
            return (eval("x." + $this.parm) > eval("y." + $this.parm)) ? -1 : 1
        }//通过eval对json对象的键值传参
        var up = function (x, y) {
            return (eval("x." + $this.parm) < eval("y." + $this.parm)) ? -1 : 1
        }
        if (this.b == "desc") {
            this.obj.sort(down)
        }
        else {
            this.obj.sort(up)
        }

    },//排序

    print: function (panelID) {
        var $text = "<div>"
        $.each(this.obj, function (key, value) {
            var $div = "<div>"
            $.each(value, function (key, value) {
                $div += "<span>" + key + ":</span>" + "<span>" + value + "</span>" + "         "
            })
            $div += "</div>"
            $text = $text + $div
        })
        $text += "</div>"
        $("#" + panelID).html($text)
    }//遍历添加dom元素，添加dom
}

function JsonArrSort() {
    this.init.apply(this, arguments)
}

JsonArrSort.prototype = JSONArraySort;

//var sort1 = new JsonArrSort(objArr, "price", "desc") //建立对象
//sort1.init(objArr, "age", "asc");//初始化参数更改
//sort1.sort();
//sort1.print();