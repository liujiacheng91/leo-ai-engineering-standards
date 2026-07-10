# implement_rule.md

描述edi服务实现的接入规则，receive，send服务，如何实现，如何通过注解与实现服务绑定。
同时约定整个项目实现的包规范。

---

## package Architecture

```
ediKsmartServiceInstance (root)
├── edi-business-common          # 框架工具类
├── edi-business-realization/    # 各客户EDI实现模块
│   ├── edi-XXX-realization  # 具体的客户实现模块
└── service/edi-ksmart-service   # Spring Boot 主应用入口，不含业务逻辑
```

`edi-business-common` 提供框架工具类，各 `*-realization` 模块只实现客户特定的业务逻辑。主服务通过 classpath 扫描加载所有 realization 模块的 Spring Bean。

---

## EDI Processing Pattern

所有 EDI 数据处理遵循统一的两层结构，process接入外部请求，service实现业务逻辑。

### Receive Service

#### 接收服务入口类（Process）

继承 `EdiReceiveCustomizeBaseProcessAbstract`，通过 override 6 个方法注册场景信息：

```java
@Component
public class XxxProcess extends EdiReceiveCustomizeBaseProcessAbstract {
    @Override public String getSceneCode()    { return "SCENE_CODE"; }
    @Override public String getSceneVersion() { return "0.0.1"; }
    @Override public String getCustomerCode() { return "CUSTOMER"; }
    @Override public String getCustomerScope(){ return "SCOPE"; }
    @Override public String getEdiCode()      { return "edi_code"; }
    @Override public String getEdiCustomer()  { return "CUSTOMER"; }
}
```

#### 业务实现类（ServiceImpl）

实现 `EdiReceiveStrategy<String>` 接口，通过 `@EdiReceiveAdapter` 注解与入口类的 `EdiCode` , `EdiCustomer` 绑定：

```java
@Component
@EdiReceiveAdapter(EdiCode = "edi_code", EdiCustomer = "CUSTOMER")
public class XxxServiceImpl implements EdiReceiveStrategy<String> {
    @Override
    public Revert receiveData(DispatcherRequest dispatcherRequest) {
        String content = dispatcherRequest.getRequestBody().getBusinessContent();
        // ... 业务逻辑 ...
        return new Revert.Builder().status(true).code(200).build();
    }
}
```

### Send Service

#### 发送服务入口类（Process）

继承 `EdiSendCustomizeBaseProcessAbstract`，通过 override 6 个方法注册场景信息：

```java
@Component
public class XxxProcess extends EdiSendCustomizeBaseProcessAbstract {
    @Override public String getSceneCode()    { return "SCENE_CODE"; }
    @Override public String getSceneVersion() { return "0.0.1"; }
    @Override public String getCustomerCode() { return "CUSTOMER"; }
    @Override public String getCustomerScope(){ return "SCOPE"; }
    @Override public String getEdiCode()      { return "edi_code"; }
    @Override public String getEdiCustomer()  { return "CUSTOMER"; }
}
```

### 业务实现类（ServiceImpl）

实现 `EdiSendStrategy<Object>` 接口，通过 `@EdiSendAdapter` 注解与入口类的 `EdiCode` , `EdiCustomer` 绑定：

```java
@Component
@EdiSendAdapter(EdiCode = "edi_code", EdiCustomer = "CUSTOMER")
public class XxxServiceImpl implements EdiSendStrategy<String> {
    @Override
    public Revert sendData(DispatcherRequest dispatcherRequest) {
        String content = dispatcherRequest.getRequestBody().getBusinessContent();
        // ... 业务逻辑 ...
        return new Revert.Builder().status(true).code(200).build();
    }
}
```


`EdiCode`, `EdiCustomer` 是入口类和实现类的绑定键，两者必须完全一致（大小写敏感）。

## other Implementation

1. `edi-{customer}-realization` 的`/build.gradle` 中添加 `api project(':edi-business-common')`
2. 在 `settings.gradle` 中 `include` 新模块
3. 在模块中创建 `process/` 和 `service/impl/` 包

---

## Configuration
