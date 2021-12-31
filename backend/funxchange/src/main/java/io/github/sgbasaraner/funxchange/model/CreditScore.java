package io.github.sgbasaraner.funxchange.model;

public class CreditScore {
    final int credit;
    final int creditOnHold;

    public CreditScore(int credit, int creditOnHold) {
        this.credit = credit;
        this.creditOnHold = creditOnHold;
    }

    public int getCredit() {
        return credit;
    }

    public int getCreditOnHold() {
        return creditOnHold;
    }

    public boolean canAfford(int creditValue) {
        return (getCredit() - getCreditOnHold()) >= creditValue;
    }
}
